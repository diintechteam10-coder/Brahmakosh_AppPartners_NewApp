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

  // Store listeners for reconnect and for managing multiple handlers
  final Map<String, List<Function(dynamic)>> _listeners = {};

  Future<void> connect(String token) async {
    if (_disposed) return;
    debugPrint(
      "🔌 [SOCKET] connect() called with token: ${token.substring(0, token.length > 10 ? 10 : token.length)}...",
    );

    disconnect();

    _socket = IO.io("https://prod.brahmakosh.com", {
      "path": "/socket.io/",
      "transports": ["polling", "websocket"],
      "autoConnect": false,
      "reconnection": true,
      "extraHeaders": {"Authorization": "Bearer $token"},
    });

    debugPrint("🔌 [SOCKET] IO instance created, calling connect()...");

    _socket!.onAny((event, data) {
      final now = DateTime.now();
      final isCancel = event.toString().contains("cancel") ||
          data.toString().contains("cancel") ||
          event.toString().contains("ended");
      final tag = isCancel ? "🔴 [CANCELLATION_EVENT]" : "📡 [SOCKET_ANY]";
      debugPrint("$tag [$now] Event: $event | Data: $data");
    });

    _socket!.onConnect((_) {
      debugPrint("🔌 [SOCKET] Connected successfully!");
      _connectedCtrl.add(true);
      debugPrint("🟢 SOCKET CONNECTED ${_socket!.id}");

      // Sync all registered listeners to the new socket instance
      _listeners.forEach((event, handlers) {
        _socket!.off(event); // Clear socket's internal list for this event
        for (final h in handlers) {
          _socket!.on(event, h);
        }
      });
    });

    // Added generic notification listener
    _socket!.on("notification", (data) {
      final now = DateTime.now();
      debugPrint("📡 [GENERIC_NOTIFICATION] [$now] Data: $data");
    });

    _socket!.onDisconnect((_) {
      _connectedCtrl.add(false);
      debugPrint("🟡 SOCKET DISCONNECTED");
    });

    _socket!.onConnectError((e) => debugPrint("🔴 CONNECT ERROR $e"));
    _socket!.onError((e) => debugPrint("🔴 SOCKET ERROR $e"));

    _socket!.connect();
  }

  void disconnect() {
    if (_socket != null) {
      debugPrint("🔌 SOCKET DISCONNECT CALLED");
      _socket!.disconnect();
      _socket!.dispose();
      _socket = null;
    }
  }

  void emit(String event, dynamic data) {
    debugPrint("📤 [SOCKET_EMIT] $event | Data: $data");
    _socket?.emit(event, data);
  }

  /// Adds a listener for an event. Supports multiple handlers per event.
  /// If the socket is already connected, it adds the listener immediately.
  /// Otherwise, it will be added when the socket connects.
  void on(String event, Function(dynamic) handler) {
    debugPrint("📥 [SOCKET_ON] Registering listener for: $event");
    _listeners.putIfAbsent(event, () => []);
    if (!_listeners[event]!.contains(handler)) {
      _listeners[event]!.add(handler);
    }

    // If socket exists, register it now
    if (_socket != null) {
      // Avoid raw duplicate on the socket instance itself
      _socket!.off(event, handler);
      _socket!.on(event, handler);
    }
  }

  /// Removes a specific handler for an event.
  /// If [handler] is null, it will do nothing (to protect global/other listeners).
  /// This prevents a controller from accidentally wiping listeners it doesn't own.
  void off(String event, [Function(dynamic)? handler]) {
    if (handler == null) {
      debugPrint(
        "⚠️ [SOCKET_OFF] Skipping 'off' for $event because handler is null. (Prevents accidental wipe-all)",
      );
      return;
    }

    debugPrint("📤 [SOCKET_OFF] Removing specific listener for: $event");
    _listeners[event]?.remove(handler);
    _socket?.off(event, handler);
  }

  void dispose() {
    _disposed = true;
    disconnect();
    _connectedCtrl.close();
  }
}
