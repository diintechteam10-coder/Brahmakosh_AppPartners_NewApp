// import 'dart:async';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart';
// import 'socket_service.dart';
// import 'socket_events.dart';

// enum WebRtcState {
//   idle,
//   connecting,
//   connected,
//   failed,
//   closed,
// }

// class WebRtcService {
//   WebRtcService._();
//   static final WebRtcService I = WebRtcService._();

//   final SocketService _socket = SocketService.I;

//   RTCPeerConnection? _pc;
//   MediaStream? _localStream;

//   String? _conversationId;

//   final _stateCtrl = StreamController<WebRtcState>.broadcast();
//   Stream<WebRtcState> get state$ => _stateCtrl.stream;

//   final _remoteStreamCtrl = StreamController<MediaStream>.broadcast();
//   Stream<MediaStream> get remoteStream$ => _remoteStreamCtrl.stream;

//   bool _initialized = false;

//   // ================= INIT =================

//   void init() {
//     if (_initialized) return;
//     _initialized = true;

//     _socket.on(SocketEvents.voiceSignal, _onSignal);
//   }

//   void dispose() {
//     _socket.off(SocketEvents.voiceSignal, _onSignal);
//     _stateCtrl.close();
//     _remoteStreamCtrl.close();
//   }

//   // ================= PUBLIC METHODS =================

//   Future<void> createConnection(String conversationId) async {
//     _conversationId = conversationId;
//     await _ensurePeerConnection();
//   }

//   Future<void> createAndSendOffer() async {
//     if (_pc == null || _conversationId == null) return;

//     _setState(WebRtcState.connecting);

//     final offer = await _pc!.createOffer({'offerToReceiveAudio': 1});
//     await _pc!.setLocalDescription(offer);

//     _socket.emit(SocketEvents.voiceSignal, {
//       'conversationId': _conversationId,
//       'signal': {
//         'type': 'offer',
//         'sdp': offer.sdp,
//       }
//     });
//   }

//   Future<void> close() async {
//     try {
//       await _localStream?.dispose();
//       await _pc?.close();
//     } catch (_) {}

//     _localStream = null;
//     _pc = null;
//     _conversationId = null;

//     _setState(WebRtcState.closed);
//   }

//   // ================= INTERNAL =================

//   Future<void> _ensurePeerConnection() async {
//     if (_pc != null) return;

//     _localStream ??= await navigator.mediaDevices.getUserMedia({
//       'audio': true,
//       'video': false,
//     });

//     final config = {
//       'iceServers': [
//         {'urls': 'stun:stun.l.google.com:19302'},
//         {'urls': 'stun:global.stun.twilio.com:3478?transport=udp'},
//       ],
//       'sdpSemantics': 'unified-plan',
//     };

//     _pc = await createPeerConnection(config);

//     for (final track in _localStream!.getTracks()) {
//       await _pc!.addTrack(track, _localStream!);
//     }

//     _pc!.onTrack = (event) {
//       if (event.streams.isNotEmpty) {
//         _remoteStreamCtrl.add(event.streams.first);
//         _setState(WebRtcState.connected);
//       }
//     };

//     _pc!.onIceCandidate = (candidate) {
//       if (candidate.candidate == null || _conversationId == null) return;

//       _socket.emit(SocketEvents.voiceSignal, {
//         'conversationId': _conversationId,
//         'signal': {
//           'type': 'candidate',
//           'candidate': candidate.toMap(),
//         }
//       });
//     };

//     _pc!.onConnectionState = (state) {
//       debugPrint("🔗 PC State: $state");
//       if (state == RTCPeerConnectionState.RTCPeerConnectionStateFailed) {
//         _setState(WebRtcState.failed);
//       }
//     };
//   }

//   Future<void> _onSignal(dynamic data) async {
//     try {
//       final convId = data['conversationId']?.toString();
//       if (convId == null || convId != _conversationId) return;

//       final signal = data['signal'];
//       if (signal == null) return;

//       await _ensurePeerConnection();

//       final type = signal['type'];

//       if (type == 'offer') {
//         await _pc!.setRemoteDescription(
//           RTCSessionDescription(signal['sdp'], 'offer'),
//         );

//         final answer =
//             await _pc!.createAnswer({'offerToReceiveAudio': 1});

//         await _pc!.setLocalDescription(answer);

//         _socket.emit(SocketEvents.voiceSignal, {
//           'conversationId': _conversationId,
//           'signal': {
//             'type': 'answer',
//             'sdp': answer.sdp,
//           }
//         });
//       }

//       else if (type == 'answer') {
//         await _pc!.setRemoteDescription(
//           RTCSessionDescription(signal['sdp'], 'answer'),
//         );
//       }

//       else if (type == 'candidate') {
//         final c = signal['candidate'];
//         await _pc!.addCandidate(
//           RTCIceCandidate(
//             c['candidate'],
//             c['sdpMid'],
//             c['sdpMLineIndex'],
//           ),
//         );
//       }
//     } catch (e) {
//       debugPrint("❌ WebRTC Signal Error: $e");
//       _setState(WebRtcState.failed);
//     }
//   }

//   void _setState(WebRtcState state) {
//     if (!_stateCtrl.isClosed) {
//       _stateCtrl.add(state);
//     }
//   }
// }