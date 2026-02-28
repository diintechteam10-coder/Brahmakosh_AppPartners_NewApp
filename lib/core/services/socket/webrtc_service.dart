import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../features/call/repository/recording_repository.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
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
  MediaStream? get localStream => _localStream;
  MediaStream? _remoteStream;
  MediaStream? get remoteStream => _remoteStream;

  final _remoteStreamCtrl = StreamController<MediaStream>.broadcast();
  Stream<MediaStream> get remoteStream$ => _remoteStreamCtrl.stream;

  final _stateCtrl = StreamController<CallState>.broadcast();
  Stream<CallState> get state$ => _stateCtrl.stream;
  CallState _state = CallState.idle;
  CallState get state => _state;

  String? _conversationId;
  String? get conversationId => _conversationId;
  CallRole? _role;

  IncomingCall? _incomingCall;
  IncomingCall? get incomingCall => _incomingCall;

  bool _isMuted = false;
  bool get isMuted => _isMuted;

  bool _isSpeakerphoneOn = false;
  bool get isSpeakerphoneOn => _isSpeakerphoneOn;

  final RecordingRepository _recordingRepo = RecordingRepository();
  MediaRecorder? _recorder;
  bool _isRecording = false;
  bool get isRecording => _isRecording;
  String? _recordingPath;

  bool _initialized = false;

  void init() {
    if (_initialized) return;
    _initialized = true;

    _socket.on(SocketEvents.voiceCallIncoming, _onIncoming);
    _socket.on(SocketEvents.voiceCallAccepted, _onAccepted);
    _socket.on(SocketEvents.voiceCallRejected, _onRejected);
    _socket.on(SocketEvents.voiceCallEnded, _onEnded);
    _socket.on(SocketEvents.voiceSignal, _onSignal);
  }

  // ---------------- Socket Handlers ----------------

  void _onIncoming(dynamic data) {
    final id = data['conversationId']?.toString();
    if (id == null) return;

    if (_state != CallState.idle && _state != CallState.ended) {
      // reject automatically if already in a call
      _socket.emit(SocketEvents.voiceCallReject, {'conversationId': id});
      return;
    }

    _conversationId = id;
    _role = CallRole.callee;
    _incomingCall = IncomingCall(
      conversationId: id,
      from: (data['from'] as Map?)?.cast<String, dynamic>(),
      to: (data['to'] as Map?)?.cast<String, dynamic>(),
      startedAt: data['startedAt'] != null
          ? DateTime.tryParse(data['startedAt'].toString())
          : null,
    );
    _setState(CallState.ringing);
  }

  void _onAccepted(dynamic data) async {
    final id = data['conversationId']?.toString();
    if (id != _conversationId) return;

    _setState(CallState.connecting);
    await _prepareLocalMedia();
    await _createPeerConnection();

    if (_role == CallRole.caller) {
      await _sendOffer();
    }
  }

  void _onRejected(dynamic data) {
    final id = data['conversationId']?.toString();
    debugPrint(
      "🛑 WebRtcService: _onRejected received for id: $id, current: $_conversationId",
    );
    if (id != _conversationId) return;
    _setState(CallState.ended);
    cleanup();
  }

  void _onEnded(dynamic data) {
    final id = data['conversationId']?.toString();
    debugPrint(
      "🛑 WebRtcService: _onEnded received for id: $id, current: $_conversationId",
    );
    if (id != _conversationId) return;
    _setState(CallState.ended);
    cleanup();
  }

  void _onSignal(dynamic data) async {
    final id = data['conversationId']?.toString();
    if (id != _conversationId) return;

    final signal = data['signal'] as Map?;
    if (signal == null) return;

    final type = signal['type']?.toString();
    final sdp = signal['sdp']?.toString();

    if (type == 'offer' && sdp != null) {
      await _prepareLocalMedia();
      await _createPeerConnection();
      await _pc!.setRemoteDescription(RTCSessionDescription(sdp, 'offer'));
      final answer = await _pc!.createAnswer();
      await _pc!.setLocalDescription(answer);
      _socket.emit(SocketEvents.voiceSignal, {
        'conversationId': _conversationId,
        'signal': {'type': 'answer', 'sdp': answer.sdp},
      });
      _setState(CallState.inCall);
    } else if (type == 'answer' && sdp != null) {
      await _pc?.setRemoteDescription(RTCSessionDescription(sdp, 'answer'));
      _setState(CallState.inCall);
    } else if (type == 'candidate') {
      final cand = signal['candidate'] as Map?;
      if (cand != null) {
        final candidate = RTCIceCandidate(
          cand['candidate'],
          cand['sdpMid'],
          cand['sdpMLineIndex'],
        );
        _pc?.addCandidate(candidate);
      }
    }
  }

  // ---------------- Call Controls ----------------

  Future<void> startCall(String conversationId) async {
    _conversationId = conversationId;
    _role = CallRole.caller;
    _setState(CallState.connecting);

    _socket.emit(SocketEvents.voiceCallInitiate, {
      'conversationId': conversationId,
    });
  }

  Future<void> acceptCall() async {
    _socket.emit(SocketEvents.voiceCallAccept, {
      'conversationId': _conversationId,
    });
  }

  Future<void> rejectCall() async {
    _socket.emit(SocketEvents.voiceCallReject, {
      'conversationId': _conversationId,
    });
    _setState(CallState.ended);
    cleanup();
  }

  Future<void> endCall() async {
    _socket.emit(SocketEvents.voiceCallEnd, {
      'conversationId': _conversationId,
    });
    _setState(CallState.ended);
    cleanup();
  }

  // ---------------- WebRTC Setup ----------------

  Future<void> _prepareLocalMedia() async {
    if (_localStream != null) return;

    await Permission.microphone.request();
    _localStream = await navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': false,
    });
  }

  Future<void> _createPeerConnection() async {
    if (_pc != null) return;

    final config = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ],
      'sdpSemantics': 'unified-plan',
    };

    _pc = await createPeerConnection(config);

    _pc?.onIceConnectionState = (state) {
      debugPrint("🧊 ICE Connection State: ${state.name}");
      if (state == RTCIceConnectionState.RTCIceConnectionStateDisconnected ||
          state == RTCIceConnectionState.RTCIceConnectionStateFailed ||
          state == RTCIceConnectionState.RTCIceConnectionStateClosed) {
        _setState(CallState.ended);
        cleanup();
      }
    };

    _pc?.onConnectionState = (state) {
      debugPrint("🔌 Peer Connection State: ${state.name}");
      if (state == RTCPeerConnectionState.RTCPeerConnectionStateDisconnected ||
          state == RTCPeerConnectionState.RTCPeerConnectionStateFailed ||
          state == RTCPeerConnectionState.RTCPeerConnectionStateClosed) {
        _setState(CallState.ended);
        cleanup();
      }
    };

    _localStream?.getTracks().forEach((track) {
      _pc?.addTrack(track, _localStream!);
    });

    _pc?.onIceCandidate = (candidate) {
      if (candidate != null) {
        _socket.emit(SocketEvents.voiceSignal, {
          'conversationId': _conversationId,
          'signal': {'type': 'candidate', 'candidate': candidate.toMap()},
        });
      }
    };

    _pc?.onTrack = (event) {
      if (event.streams.isNotEmpty) {
        _remoteStream = event.streams.first;
        _remoteStreamCtrl.add(_remoteStream!);
        debugPrint("📡 Remote stream received");
      }
    };
  }

  Future<void> _sendOffer() async {
    final offer = await _pc!.createOffer();
    await _pc!.setLocalDescription(offer);
    _socket.emit(SocketEvents.voiceSignal, {
      'conversationId': _conversationId,
      'signal': {'type': 'offer', 'sdp': offer.sdp},
    });
  }

  // ---------------- Media Controls ----------------

  void toggleMute() {
    if (_localStream != null) {
      _isMuted = !_isMuted;
      _localStream!.getAudioTracks().forEach((track) {
        track.enabled = !_isMuted;
      });
    }
  }

  void toggleSpeaker() {
    _isSpeakerphoneOn = !_isSpeakerphoneOn;
    Helper.setSpeakerphoneOn(_isSpeakerphoneOn);
  }

  // ---------------- Recording ----------------
  Future<void> _startRecording() async {
    if (_isRecording) return;

    try {
      if (_localStream == null) {
        debugPrint("❌ Recording failed: Local stream is null");
        return;
      }

      final audioTracks = _localStream!.getAudioTracks();
      if (audioTracks.isEmpty) {
        debugPrint("❌ Recording failed: No audio tracks found");
        return;
      }

      final dir = await getTemporaryDirectory();
      _recordingPath =
          '${dir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.webm';

      _recorder = MediaRecorder();

      await _recorder!.start(
        _recordingPath!,
        audioChannel: RecorderAudioChannel.INPUT,
      );

      _isRecording = true;
      debugPrint("⏺️ Recording started at $_recordingPath");
    } catch (e) {
      debugPrint("❌ Failed to start recording: $e");
    }
  }

  Future<void> _stopAndUploadRecording() async {
    if (!_isRecording || _recorder == null) return;

    try {
      debugPrint("⏹️ Stopping recording...");
      await _recorder!.stop();
      _isRecording = false;

      final convIdToUpload = _conversationId;
      if (convIdToUpload == null) {
        debugPrint("❌ conversationId null, skipping upload");
        return;
      }

      final path = _recordingPath;
      if (path == null) return;

      final file = File(path);
      if (!await file.exists()) return;

      final fileBytes = await file.readAsBytes();
      final uploadData = await _recordingRepo.getUploadUrl(
        conversationId: convIdToUpload,
      );
      // final uploadUrl = await _recordingRepo.getUploadUrl(
      //   conversationId: convIdToUpload,
      // );

      if (uploadData == null) return;

      await _recordingRepo.uploadRecordingFile(
        uploadUrl: uploadData['uploadUrl'],

        // uploadUrl: uploadUrl,
        fileBytes: fileBytes,
      );

      await _recordingRepo.attachRecordingToConversation(
        conversationId: convIdToUpload,
        audioKey: uploadData['audioKey'],
        audioUrl: uploadData['audioUrl'],
      );

      await file.delete();
    } catch (e) {
      debugPrint("❌ Error while stopping/uploading recording: $e");
    }
  }
  //     // Cleanup temp file
  //     if (await file.exists()) {
  //       await file.delete();
  //       debugPrint("🗑️ WebRtcService: Deleted temp recording file.");
  //     }
  //   } catch (e) {
  //     debugPrint("❌ WebRtcService: Error during stop/upload recording: $e");
  //   }
  // }

  Future<void> cleanup() async {
    debugPrint("🧹 WebRtcService: cleanup called.");
    await _localStream?.dispose();
    _localStream = null;

    await _pc?.close();
    _pc = null;

    _remoteStream = null;
    _conversationId = null;
    _incomingCall = null;
    _role = null;

    _isMuted = false;
    _isSpeakerphoneOn = false;
    Helper.setSpeakerphoneOn(false);

    _setState(CallState.idle);
  }

  void _setState(CallState s) {
    if (_state == s) return; // 👈 THIS LINE FIXES DOUBLE CALL

    debugPrint("🔄 State changed to ${s.name}");
    _state = s;

    if (s == CallState.inCall) {
      Future.delayed(const Duration(milliseconds: 400), () {
        if (_state == CallState.inCall) {
          _startRecording();
        }
      });
    }

    if (s == CallState.ended) {
      _stopAndUploadRecording();
    }

    _stateCtrl.add(s);
  }
}
