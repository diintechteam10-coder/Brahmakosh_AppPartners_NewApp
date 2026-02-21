// // import 'dart:async';
// // import 'package:flutter/foundation.dart';
// // import 'package:socket_io_client_new/socket_io_client_new.dart' as IO;
// // import '../utils/app_keys.dart';
// // import 'sharedpreferences_service.dart';
// // import '../const/app_urls.dart'; // Added import

// // class SocketService {
// //   SocketService._();
// //   static final SocketService I = SocketService._();

// //   IO.Socket? _socket;
// //   bool _disposed = false;

// //   final _connectedCtrl = StreamController<bool>.broadcast();
// //   Stream<bool> get connected$ => _connectedCtrl.stream;
// //   bool get isConnected => _socket?.connected ?? false;

// //   final _eventsCtrl = StreamController<Map<String, dynamic>>.broadcast();
// //   Stream<Map<String, dynamic>> get events$ => _eventsCtrl.stream;

// //   Future<void> connect([String? token]) async {
// //     if (_disposed) return;

// //     final actualToken = (token != null && token.isNotEmpty)
// //         ? token
// //         : await _getTokenFromPrefs();

// //     const baseUrl = "https://stage.brahmakosh.com";
// //     const path = '/socket.io/';
// //     const printLogs = true;

// //     disconnect(printLogs: printLogs);

// //     _socket = IO.io(baseUrl, <String, dynamic>{
// //       'path': path,
// //       'transports': ['polling'],
// //       'autoConnect': false,
// //       'reconnection': true,
// //       'forceNew': true,
// //       'pingTimeout': 60000,
// //       'pingInterval': 25000,
// //       'query': {if ((actualToken ?? '').isNotEmpty) 'token': actualToken},
// //       'extraHeaders': {
// //         if ((actualToken ?? '').isNotEmpty) 'Authorization': actualToken,
// //       },
// //     });

// //     _socket?.connect();

// //     final s = _socket!;

// //     s.onConnect((_) {
// //       _safeConnected(true);
// //       _safeEvent({
// //         'type': 'connect',
// //         'socketId': s.id,
// //         'engineUrl': s.io.uri,
// //       }, printLogs);
// //     });

// //     s.onConnectError((err) {
// //       _safeConnected(false);
// //       _safeEvent({
// //         'type': 'connect_error',
// //         'error': err.toString(),
// //         'engineUrl': s.io.uri,
// //       }, printLogs);
// //     });

// //     s.onDisconnect((reason) {
// //       _safeConnected(false);
// //       _safeEvent({'type': 'disconnect', 'reason': reason}, printLogs);
// //     });

// //     s.onError((err) {
// //       _safeEvent({'type': 'error', 'error': err.toString()}, printLogs);
// //     });
// //   }

// //   void emit(String event, dynamic data) => _socket?.emit(event, data);

// //   void on(String event, Function(dynamic) handler) =>
// //       _socket?.on(event, handler);

// //   void off(String event, [Function(dynamic)? handler]) =>
// //       _socket?.off(event, handler);

// //   void disconnect({bool printLogs = true}) {
// //     final s = _socket;
// //     _socket = null;

// //     try {
// //       s?.disconnect();
// //       s?.dispose();
// //     } catch (_) {}

// //     _safeConnected(false);
// //     _safeEvent({'type': 'disconnect_local'}, printLogs);
// //   }

// //   void dispose() {
// //     _disposed = true;
// //     disconnect(printLogs: false);
// //     _connectedCtrl.close();
// //     _eventsCtrl.close();
// //   }

// //   Future<String?> _getTokenFromPrefs() async {
// //     try {
// //       final prefsService = await SharedPreferencesService.getInstance();
// //       return prefsService.getString(AppKeys.token);
// //     } catch (_) {
// //       return null;
// //     }
// //   }

// //   void _safeConnected(bool v) {
// //     if (_disposed) return;
// //     if (!_connectedCtrl.isClosed) _connectedCtrl.add(v);
// //   }

// //   void _safeEvent(Map<String, dynamic> e, bool printLogs) {
// //     if (_disposed) return;

// //     if (kDebugMode && printLogs) {
// //       final icon = _iconFor(e['type']);
// //       final body = Map<String, dynamic>.from(e)..remove('type');
// //       print('$icon [${e['type']}] ${body.isEmpty ? '' : body}');
// //     }

// //     if (!_eventsCtrl.isClosed) _eventsCtrl.add(e);
// //   }

// //   String _iconFor(String? type) {
// //     switch (type) {
// //       case 'connect':
// //         return '🟢';
// //       case 'disconnect':
// //         return '🟡';
// //       case 'disconnect_local':
// //         return '⚪';
// //       case 'connect_error':
// //       case 'error':
// //         return '🔴';
// //       default:
// //         return '🔵';
// //     }
// //   }
// // }

// import 'dart:async';
// import 'package:flutter/foundation.dart';
// import 'package:socket_io_client_new/socket_io_client_new.dart' as IO;
// import 'socket_events.dart';

// class SocketService {
//   SocketService._();
//   static final SocketService I = SocketService._();

//   IO.Socket? _socket;
//   bool _disposed = false;

//   final _connectedCtrl = StreamController<bool>.broadcast();
//   Stream<bool> get connected$ => _connectedCtrl.stream;
//   bool get isConnected => _socket?.connected ?? false;

//   // ================= CONNECT =================

//   // Store listeners here so we can re-attach them on reconnect
//   final Map<String, List<Function(dynamic)>> _listeners = {};

//   // ================= CONNECT =================

//   Future<void> connect(String token) async {
//     if (_disposed) return;

//     // Don't disconnect if already connected with same token?
//     // For now, force reconnect as per original logic.
//     disconnect();

//     _socket = IO.io("https://stage.brahmakosh.com", {
//       "path": "/socket.io/",
//       "transports": ["polling"], // required in Flutter
//       "autoConnect": false,
//       "reconnection": true,
//       "extraHeaders": {"Authorization": token},
//     });

//     _socket!.connect();

//     _socket!.onConnect((_) {
//       _connectedCtrl.add(true);
//       debugPrint("🟢 SOCKET CONNECTED ${_socket!.id}");

//       // Re-attach all cached listeners
//       _listeners.forEach((event, handlers) {
//         for (final handler in handlers) {
//           _socket!.on(event, handler);
//         }
//       });
//     });

//     _socket!.onDisconnect((_) {
//       _connectedCtrl.add(false);
//       debugPrint("🟡 SOCKET DISCONNECTED");
//     });

//     // ✅ DEBUGGING: Log ALL incoming events
//     _socket!.onAny((event, data) {
//       debugPrint("🔥 SOCKET EVENT: $event -> $data");
//     });

//     _socket!.on("error", (err) => debugPrint("Socket Error: $err"));
//     _socket!.on("connect_error", (err) => debugPrint("Connect Error: $err"));

//     _socket!.onConnectError((e) {
//       debugPrint("🔴 CONNECT ERROR $e");
//     });
//   }

//   void disconnect() {
//     _socket?.disconnect();
//     _socket?.dispose();
//     _socket = null;
//     // _listeners.clear(); // Keep listeners? Assuming we want them to persist across reconnects.
//   }

//   // ================= GENERIC =================

//   void emit(String event, dynamic data) => _socket?.emit(event, data);

//   void on(String event, Function(dynamic) handler) {
//     if (_listeners[event] == null) {
//       _listeners[event] = [];
//     }
//     _listeners[event]!.add(handler);

//     // If socket is already active, register immediately
//     _socket?.on(event, handler);
//   }

//   void off(String event, [Function(dynamic)? handler]) {
//     if (handler != null) {
//       _listeners[event]?.remove(handler);
//       _socket?.off(event, handler);
//     } else {
//       _listeners.remove(event);
//       _socket?.off(event);
//     }
//   }

//   // ================= PRESENCE =================

//   void goOnline() {
//     emit(SocketEvents.partnerOnline, {});
//   }

//   void updateStatus(String status) {
//     emit(SocketEvents.partnerStatusUpdate, {"status": status});
//   }

//   void listenStatusChanged(Function(dynamic) fn) {
//     on(SocketEvents.partnerStatusChanged, fn);
//   }

//   // ================= CONVERSATION =================

//   void listenNewConversationRequest(Function(dynamic) fn) {
//     on(SocketEvents.newConversationRequest, fn);
//   }

//   void joinConversation(String id) {
//     emit(SocketEvents.joinConversation, {"conversationId": id});
//   }

//   void leaveConversation(String id) {
//     emit(SocketEvents.leaveConversation, {"conversationId": id});
//   }

//   void bulkJoin(List<String> ids) {
//     emit(SocketEvents.bulkJoinConversation, {"conversationIds": ids});
//   }

//   // ================= MESSAGING =================

//   void sendMessage({
//     required String conversationId,
//     required String content,
//     String type = "text",
//     String? mediaUrl,
//   }) {
//     emit(SocketEvents.sendMessage, {
//       "conversationId": conversationId,
//       "content": content,
//       "messageType": type,
//       "mediaUrl": mediaUrl,
//     });
//   }

//   void markRead(String conversationId, {List<String>? messageIds}) {
//     emit(SocketEvents.messageRead, {
//       "conversationId": conversationId,
//       if (messageIds != null) "messageIds": messageIds,
//     });
//   }

//   void listenNewMessage(Function(dynamic) fn) {
//     on(SocketEvents.newMessage, fn);
//   }

//   void listenDelivered(Function(dynamic) fn) {
//     on(SocketEvents.messageDelivered, fn);
//   }

//   void listenReadReceipt(Function(dynamic) fn) {
//     on(SocketEvents.readReceipt, fn);
//   }

//   // ================= TYPING =================

//   void startTyping(String id) {
//     emit(SocketEvents.typingStart, {"conversationId": id});
//   }

//   void stopTyping(String id) {
//     emit(SocketEvents.typingStop, {"conversationId": id});
//   }

//   void listenTyping(Function(dynamic) fn) {
//     on(SocketEvents.typingStatus, fn);
//   }

//   // ================= DISPOSE =================

//   void dispose() {
//     _disposed = true;
//     disconnect();
//     _connectedCtrl.close();
//   }
// }
