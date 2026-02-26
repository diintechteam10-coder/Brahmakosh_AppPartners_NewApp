import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import '../../../features/call/repository/recording_repository.dart';
import 'package:get/get.dart' hide navigator;
import 'socket_service.dart';
import 'socket_events.dart';

enum CallRole { caller, callee }

enum CallState { idle, ringing, connecting, inCall, ending, ended, failed }

class IncomingCall {
  final String conversationId;
  final Map<String, dynamic>? from;
  final Map<String, dynamic>? to;
  final DateTime? startedAt;

  IncomingCall({
    required this.conversationId,
    this.from,
    this.to,
    this.startedAt,
  });
}

class WebRtcService {
  WebRtcService._();
  static final WebRtcService I = WebRtcService._();

  final SocketService _socket = SocketService.I;

  RTCPeerConnection? _pc;
  MediaStream? _localStream;

  CallRole? _role;
  String? _conversationId;

  final _stateCtrl = StreamController<CallState>.broadcast();
  Stream<CallState> get state$ => _stateCtrl.stream;
  CallState _state = CallState.idle;
  CallState get state => _state;

  final _incomingCtrl = StreamController<IncomingCall>.broadcast();
  Stream<IncomingCall> get incoming$ => _incomingCtrl.stream;

  final _remoteStreamCtrl = StreamController<MediaStream>.broadcast();
  Stream<MediaStream> get remoteStream$ => _remoteStreamCtrl.stream;

  MediaStream? _remoteStream;
  MediaStream? get remoteStream => _remoteStream;

  // Keep handler refs so we can off() cleanly
  late final Function(dynamic) _onIncomingHandler;
  late final Function(dynamic) _onAcceptedHandler;
  late final Function(dynamic) _onRejectedHandler;
  late final Function(dynamic) _onEndedHandler;
  late final Function(dynamic) _onSignalHandler;

  MediaRecorder? _audioRecorder;
  String? _audioFilePath;
  final RecordingRepository _recordingRepo = RecordingRepository();

  bool _initialized = false;
  bool _isInitializingPc = false;
  final List<RTCIceCandidate> _earlyCandidates = [];

  /// Call this once (e.g., after socket connected)
  void init() {
    if (_initialized) return;
    _initialized = true;

    _onIncomingHandler = (data) async {
      try {
        final convId = data['conversationId']?.toString();
        debugPrint("📥 voice:call:incoming -> ID: $convId, Data: $data");

        if (convId == null || convId.isEmpty) return;

        // If already in a call, you can auto-reject or ignore.
        if (_state != CallState.idle && _state != CallState.ended) {
          debugPrint("⚠️ Incoming call while busy. Ignoring.");
          return;
        }

        _conversationId = convId;
        _role = CallRole.callee;
        _setState(CallState.ringing);

        _incomingCtrl.add(
          IncomingCall(
            conversationId: convId,
            from: (data['from'] as Map?)?.cast<String, dynamic>(),
            to: (data['to'] as Map?)?.cast<String, dynamic>(),
            startedAt: _tryParseDate(data['startedAt']),
          ),
        );
      } catch (e) {
        debugPrint("❌ voice:call:incoming handler error: $e");
      }
    };

    _onAcceptedHandler = (data) async {
      // Caller gets this after callee accepts
      try {
        final convId = data['conversationId']?.toString();
        if (convId == null || convId != _conversationId) return;

        debugPrint("✅ voice:call:accepted $data");
        _setState(CallState.connecting);

        // Caller creates offer and sends
        if (_role == CallRole.caller) {
          await _ensurePeerConnection();
          await _createAndSendOffer();
        }
      } catch (e) {
        debugPrint("❌ voice:call:accepted handler error: $e");
        _failAndCleanup();
      }
    };

    _onRejectedHandler = (data) async {
      try {
        final convId = data['conversationId']?.toString();
        if (convId == null || convId != _conversationId) return;

        debugPrint("🚫 voice:call:rejected $data");
        _setState(CallState.ended);
        await cleanup();
      } catch (e) {
        debugPrint("❌ voice:call:rejected handler error: $e");
      }
    };

    _onEndedHandler = (data) async {
      try {
        final convId = data['conversationId']?.toString();
        if (convId == null || convId != _conversationId) return;

        debugPrint("🛑 voice:call:ended $data");
        _setState(CallState.ended);
        await cleanup();
      } catch (e) {
        debugPrint("❌ voice:call:ended handler error: $e");
      }
    };

    _onSignalHandler = (data) async {
      try {
        final convId = data['conversationId']?.toString();
        if (convId == null || convId != _conversationId) return;

        final signal = (data['signal'] as Map?)?.cast<String, dynamic>();
        if (signal == null) return;

        await _ensurePeerConnection();

        final type = signal['type']?.toString();
        if (type == 'offer') {
          // Callee receives offer
          final sdp = signal['sdp']?.toString();
          if (sdp == null) return;

          try {
            await _pc!.setRemoteDescription(
              RTCSessionDescription(sdp, 'offer'),
            );
            final answer = await _pc!.createAnswer({'offerToReceiveAudio': 1});
            await _pc!.setLocalDescription(answer);

            _socket.emit(SocketEvents.voiceSignal, {
              'conversationId': _conversationId,
              'signal': {'type': 'answer', 'sdp': answer.sdp},
            });

            _setState(CallState.inCall);
          } catch (e) {
            debugPrint("⚠️ Failed to process offer (duplicate?): $e");
          }
        } else if (type == 'answer') {
          // Caller receives answer
          final sdp = signal['sdp']?.toString();
          if (sdp == null) return;

          try {
            await _pc!.setRemoteDescription(
              RTCSessionDescription(sdp, 'answer'),
            );
            _setState(CallState.inCall);
          } catch (e) {
            debugPrint("⚠️ Failed to process answer: $e");
          }
        } else if (type == 'candidate') {
          final c = (signal['candidate'] as Map?)?.cast<String, dynamic>();
          if (c == null) return;

          final candidate = RTCIceCandidate(
            c['candidate']?.toString(),
            c['sdpMid']?.toString(),
            (c['sdpMLineIndex'] is int)
                ? c['sdpMLineIndex'] as int
                : int.tryParse('${c['sdpMLineIndex']}'),
          );
          try {
            if (_pc == null) {
              debugPrint(
                "⏳ PC is null. Discarding early ICE candidate to avoid native crash.",
              );
              // _earlyCandidates.add(candidate); // Disabled: Queueing causes Reply already submitted exceptions natively sometimes
            } else {
              await _pc!.addCandidate(candidate);
            }
          } catch (e) {
            debugPrint("⚠️ Failed to queue/add ICE candidate: $e");
          }
        }
      } catch (e) {
        debugPrint("❌ voice:signal handler fatal error: $e");
        _failAndCleanup();
      }
    };

    // Attach listeners
    _socket.on(SocketEvents.voiceCallIncoming, _onIncomingHandler);
    _socket.on(SocketEvents.voiceCallAccepted, _onAcceptedHandler);
    _socket.on(SocketEvents.voiceCallRejected, _onRejectedHandler);
    _socket.on(SocketEvents.voiceCallEnded, _onEndedHandler);
    _socket.on(SocketEvents.voiceSignal, _onSignalHandler);
  }

  /// Start outgoing call (caller)
  Future<void> startCall({required String conversationId}) async {
    if (!_socket.isConnected) {
      debugPrint("⚠️ Socket not connected");
      return;
    }

    if (_state != CallState.idle && _state != CallState.ended) {
      debugPrint("⚠️ Already in call state: $_state");
      return;
    }

    _conversationId = conversationId;
    _role = CallRole.caller;
    _setState(CallState.connecting);

    _socket.emitWithAck(
      SocketEvents.voiceCallInitiate,
      {'conversationId': conversationId},
      ack: (resp) {
        debugPrint("📞 voice:call:initiate ack: $resp");
        // Now wait for voice:call:accepted OR rejected
      },
    );
  }

  /// Accept incoming call (callee)
  Future<void> acceptCall() async {
    if (_conversationId == null) return;

    _setState(CallState.connecting);
    await _ensurePeerConnection();

    _socket.emitWithAck(
      SocketEvents.voiceCallAccept,
      {'conversationId': _conversationId},
      ack: (resp) {
        debugPrint("✅ voice:call:accept ack: $resp");
        // Callee will receive offer via voice:signal
      },
    );
  }

  /// Reject incoming call (callee)
  Future<void> rejectCall({String? reason}) async {
    if (_conversationId == null) return;

    _socket.emitWithAck(
      SocketEvents.voiceCallReject,
      {'conversationId': _conversationId, if (reason != null) 'reason': reason},
      ack: (resp) {
        debugPrint("🚫 voice:call:reject ack: $resp");
      },
    );

    _setState(CallState.ended);
    await cleanup();
  }

  /// End call (either side)
  Future<void> endCall() async {
    if (_conversationId == null) return;

    _setState(CallState.ending);

    _socket.emitWithAck(
      SocketEvents.voiceCallEnd,
      {'conversationId': _conversationId},
      ack: (resp) {
        debugPrint("🛑 voice:call:end ack: $resp");
      },
    );

    // other side will get voice:call:ended, but we cleanup locally too
    _setState(CallState.ended);
    await cleanup();
  }

  /// Cleanup WebRTC resources
  Future<void> cleanup() async {
    try {
      await _localStream?.dispose();
    } catch (_) {}
    _localStream = null;

    try {
      await _pc?.close();
    } catch (_) {}
    _pc = null;
    _earlyCandidates.clear();
    _remoteStream = null;

    _conversationId = null;
    _role = null;

    if (!_disposedState()) _setState(CallState.idle);
  }

  /// Start Recording
  Future<void> _startRecording() async {
    try {
      if (_localStream == null) {
        debugPrint("⚠️ Cannot start recording: no local stream");
        return;
      }

      final dir = await getTemporaryDirectory();
      _audioFilePath =
          '${dir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.webm';

      _audioRecorder = MediaRecorder();
      await _audioRecorder!.start(
        _audioFilePath!,
        videoTrack: null,
        audioChannel: RecorderAudioChannel.INPUT,
      );

      debugPrint("🎙️ Recording started at $_audioFilePath");
    } catch (e) {
      debugPrint("❌ Recording start failed: $e");
    }
  }

  /// Stop and Upload Recording
  Future<void> _stopAndUploadRecording(String convId) async {
    try {
      if (_audioRecorder != null) {
        await _audioRecorder!.stop();
        _audioRecorder = null;
        debugPrint("⏹️ Recording stopped.");
      }

      if (_audioFilePath != null && File(_audioFilePath!).existsSync()) {
        final audioFile = File(_audioFilePath!);
        final bytes = await audioFile.readAsBytes();

        if (bytes.isEmpty) {
          debugPrint("⚠️ Recording is empty.");
          return;
        }

        debugPrint("⬆️ Uploading recording for convId: $convId");

        // 1. Get URL
        final uploadUrl = await _recordingRepo.getUploadUrl(
          conversationId: convId,
        );
        if (uploadUrl == null) {
          debugPrint("❌ upload URL is null");
          return;
        }

        // 2. Upload File
        final uploadSuccess = await _recordingRepo.uploadRecordingFile(
          uploadUrl: uploadUrl,
          fileBytes: bytes,
        );

        if (!uploadSuccess) {
          debugPrint("❌ File upload failed");
          return;
        }

        // 3. Attach
        final attachSuccess = await _recordingRepo
            .attachRecordingToConversation(conversationId: convId);

        if (attachSuccess) {
          debugPrint("✅ Recording successfully attached.");
        } else {
          debugPrint("❌ Failed to attach recording to conversation.");
        }
      }
    } catch (e) {
      debugPrint("❌ Recording upload flow failed: $e");
    } finally {
      _audioFilePath = null; // reset
    }
  }

  /// Must call when app exits / socket dispose
  void dispose() {
    if (!_initialized) return;

    _socket.off(SocketEvents.voiceCallIncoming, _onIncomingHandler);
    _socket.off(SocketEvents.voiceCallAccepted, _onAcceptedHandler);
    _socket.off(SocketEvents.voiceCallRejected, _onRejectedHandler);
    _socket.off(SocketEvents.voiceCallEnded, _onEndedHandler);
    _socket.off(SocketEvents.voiceSignal, _onSignalHandler);

    _stateCtrl.close();
    _incomingCtrl.close();
    _remoteStreamCtrl.close();
    _initialized = false;
  }

  // ====================== Internals ======================

  Future<void> _ensurePeerConnection() async {
    // 1. Mic permission + local stream (DO THIS FIRST OUTSIDE THE LOCK)
    if (_localStream == null) {
      // Explicitly request permission
      final status = await Permission.microphone.request();
      if (status.isPermanentlyDenied) {
        debugPrint(
          "❌ Microphone permission permanently denied. Open app settings.",
        );
        await _failAndCleanup();
        throw Exception(
          "Microphone permission permanently denied. Please enable it in app settings.",
        );
      } else if (!status.isGranted) {
        debugPrint("❌ Microphone permission denied.");
        await _failAndCleanup();
        throw Exception("Microphone permission denied.");
      }

      // Try getting user media
      try {
        _localStream = await navigator.mediaDevices.getUserMedia({
          'audio': true,
          'video': false,
        });
      } catch (e) {
        debugPrint("❌ Failed to get user media: $e");
        await _failAndCleanup();
        throw Exception("Failed to access microphone: $e");
      }
    }

    // 2. Thread-safe PeerConnection creation
    while (_isInitializingPc) {
      await Future.delayed(const Duration(milliseconds: 50));
    }

    if (_pc != null) return;

    _isInitializingPc = true;
    try {
      final pcConfig = <String, dynamic>{
        'iceServers': [
          {'urls': 'stun:stun.l.google.com:19302'},
          {'urls': 'stun:global.stun.twilio.com:3478?transport=udp'},
        ],
        'sdpSemantics': 'unified-plan',
      };

      _pc = await createPeerConnection(pcConfig);

      if (_pc == null) {
        debugPrint("❌ Failed to create PeerConnection.");
        throw Exception("Failed to create PeerConnection.");
      }

      // Small delay to let the flutter_webrtc native Android JVM fully map the _pc object
      // otherwise addTrack fires too fast and triggers `peerConnection is null` Android exception
      await Future.delayed(const Duration(milliseconds: 100));

      // Add local tracks
      if (_localStream != null) {
        for (final track in _localStream!.getTracks()) {
          try {
            await _pc!.addTrack(track, _localStream!);
          } catch (e) {
            debugPrint("❌ Error adding track: $e");
            Get.snackbar(
              'Audio Warning',
              'Failed to attach local mic: $e',
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        }
      }

      // Remote tracks
      _pc!.onTrack = (RTCTrackEvent event) {
        if (event.streams.isNotEmpty) {
          _remoteStream = event.streams.first;
          _remoteStreamCtrl.add(_remoteStream!);
        }
      };

      // ICE candidates -> send via socket
      _pc!.onIceCandidate = (RTCIceCandidate candidate) {
        if (candidate.candidate == null || _conversationId == null) return;

        _socket.emit(SocketEvents.voiceSignal, {
          'conversationId': _conversationId,
          'signal': {'type': 'candidate', 'candidate': candidate.toMap()},
        });
      };

      // Optional: for debug
      _pc!.onConnectionState = (RTCPeerConnectionState s) {
        debugPrint("🔗 PC connection state: $s");
      };

      // Output queued early candidates now that _pc is initialized
      for (final candidate in _earlyCandidates) {
        if (_pc != null) {
          try {
            // Disabled adding queued candidates to avoid "Reply already submitted" native crash
            // await _pc!.addCandidate(candidate);
            debugPrint(
              "⏳ Discarded queued early ICE candidate to avoid native crash.",
            );
          } catch (e) {
            debugPrint("⚠️ Failed adding queued candidate: $e");
          }
        }
      }
      _earlyCandidates.clear();
    } finally {
      _isInitializingPc = false;
    }
  }

  Future<void> _createAndSendOffer() async {
    if (_pc == null || _conversationId == null) return;

    final offer = await _pc!.createOffer({'offerToReceiveAudio': 1});
    await _pc!.setLocalDescription(offer);

    _socket.emit(SocketEvents.voiceSignal, {
      'conversationId': _conversationId,
      'signal': {'type': 'offer', 'sdp': offer.sdp},
    });
  }

  void _setState(CallState s) {
    if (s == CallState.inCall && _state != CallState.inCall) {
      _startRecording();
    } else if (s == CallState.ended && _state != CallState.ended) {
      if (_conversationId != null) {
        _stopAndUploadRecording(_conversationId!);
      }
    }

    _state = s;
    if (!_disposedState()) _stateCtrl.add(s);
  }

  bool _disposedState() {
    return _stateCtrl.isClosed;
  }

  DateTime? _tryParseDate(dynamic v) {
    try {
      if (v == null) return null;
      return DateTime.tryParse(v.toString());
    } catch (_) {
      return null;
    }
  }

  Future<void> _failAndCleanup() async {
    _setState(CallState.failed);
    await cleanup();
  }
}

// ============ Small helper: emitWithAck for socket service ============
// If your socket package doesn't have emitWithAck, add this extension.
extension SocketAck on SocketService {
  void emitWithAck(
    String event,
    dynamic data, {
    required Function(dynamic) ack,
  }) {
    try {
      (this).emit(event, data); // fallback if no ack
      Future.delayed(
        const Duration(milliseconds: 50),
        () => ack({'success': true}),
      );
    } catch (e) {
      ack({'success': false, 'error': e.toString()});
    }
  }
}
