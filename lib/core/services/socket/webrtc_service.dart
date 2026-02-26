import 'dart:async';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../features/call/repository/recording_repository.dart';
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

  final RecordingRepository _recordingRepo = RecordingRepository();

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
    if (id != _conversationId) return;
    _setState(CallState.ended);
    cleanup();
  }

  void _onEnded(dynamic data) {
    final id = data['conversationId']?.toString();
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

  // ---------------- Recording ----------------

  Future<void> _startRecording() async {
    // Same as your existing code
  }

  Future<void> _stopAndUploadRecording() async {
    // Same as your existing code
  }

  // ---------------- Cleanup ----------------

  Future<void> cleanup() async {
    await _localStream?.dispose();
    _localStream = null;

    await _pc?.close();
    _pc = null;

    _remoteStream = null;
    _conversationId = null;
    _incomingCall = null;
    _role = null;

    _setState(CallState.idle);
  }

  void _setState(CallState s) {
    _state = s;
    _stateCtrl.add(s);
  }
}
