import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client_new/socket_io_client_new.dart' as IO;

class SocketService {
  SocketService._();
  static final SocketService I = SocketService._();

  IO.Socket? _socket;
  bool _disposed = false;

  final _connectedCtrl = StreamController<bool>.broadcast();
  Stream<bool> get connected$ => _connectedCtrl.stream;
  bool get isConnected => _socket?.connected ?? false;

  // Store listeners for reconnect
  final Map<String, List<Function(dynamic)>> _listeners = {};

  Future<void> connect(String token) async {
    if (_disposed) return;

    disconnect();

    _socket = IO.io("https://stage.brahmakosh.com", {
      "path": "/socket.io/",
      "transports": ["polling"], // keep as your backend needs
      "autoConnect": false,
      "reconnection": true,
      "extraHeaders": {"Authorization": "Bearer $token"},
    });

    _socket!.connect();

    _socket!.onConnect((_) {
      _connectedCtrl.add(true);
      debugPrint("🟢 SOCKET CONNECTED ${_socket!.id}");

      // re-attach listeners after reconnect
      _listeners.forEach((event, handlers) {
        for (final handler in handlers) {
          _socket!.on(event, handler);
        }
      });
    });

    _socket!.onDisconnect((_) {
      _connectedCtrl.add(false);
      debugPrint("🟡 SOCKET DISCONNECTED");
    });

    _socket!.onConnectError((e) {
      debugPrint("🔴 CONNECT ERROR $e");
    });

    _socket!.onError((e) {
      debugPrint("🔴 SOCKET ERROR $e");
    });
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }

  void emit(String event, dynamic data) => _socket?.emit(event, data);

  void on(String event, Function(dynamic) handler) {
    _addListener(event, handler);
    _socket?.on(event, handler);
  }

  void off(String event, [Function(dynamic)? handler]) {
    if (handler != null) {
      _listeners[event]?.remove(handler);
      _socket?.off(event, handler);
    } else {
      _listeners.remove(event);
      _socket?.off(event);
    }
  }

  void _addListener(String event, Function(dynamic) handler) {
    _listeners.putIfAbsent(event, () => []);
    _listeners[event]!.add(handler);
  }

  void dispose() {
    _disposed = true;
    disconnect();
    _connectedCtrl.close();
  }
}
