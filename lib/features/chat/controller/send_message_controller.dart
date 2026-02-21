// import 'package:get/get.dart';

// import '../../../core/services/socket/socket_events.dart';
// import '../../../core/services/socket/socket_service.dart';
// import '../models/request/send_message_request_model.dart';
// import '../models/responses/send_msg_response_model.dart';
// import '../repository/message_repository.dart';
// import '../repository/send_message_repository.dart';
// class SendMessageController extends GetxController {
//   final SocketService socketService = Get.find<SocketService>();
//   final SendMessageRepository repository = SendMessageRepository();

//   /// send state
//   final RxBool isSending = false.obs;

//   /// last sent message (REST response)
//   final Rxn<SendMessageResponse> lastResponse = Rxn<SendMessageResponse>();

//   /// for socket typing UI (if you want to show in your UI)
//   final RxBool isTyping = false.obs;

//   late String conversationId;

//   /// call this once from ChatScreen
//   void init({required String conversationId}) {
//     this.conversationId = conversationId;
//   }

//   // ================= TYPING =================
//   /// call on TextField onChanged / listener when user starts typing
//   void typingStart() {
//     if (!isTyping.value) isTyping.value = true;
//     socketService.emit(SocketEvents.typingStart, {
//       "conversationId": conversationId,
//     });
//   }

//   /// call when input empty OR after send
//   void typingStop() {
//     if (isTyping.value) isTyping.value = false;
//     socketService.emit(SocketEvents.typingStop, {
//       "conversationId": conversationId,
//     });
//   }

//   // ================= SEND (REST) =================
//   /// REST send message using your request/response models
//   /// Endpoint in repo: POST /api/chat/conversations/:conversationId/messages
//   Future<SendMessageResponse?> sendMessageRest({
//     required String content,
//     String messageType = "text",
//   }) async {
//     final text = content.trim();
//     if (text.isEmpty) return null;

//     isSending.value = true;
//     try {
//       // stop typing when sending
//       typingStop();

//       final req = SendMessageRequest(
//         content: text,
//         messageType: messageType,
//       );

//       final res = await repository.sendMessage(
//         conversationId: conversationId,
//         request: req,
//       );

//       lastResponse.value = res;
//       return res;
//     } finally {
//       isSending.value = false;
//     }
//   }

//   // ================= SEND (SOCKET) =================
//   /// Socket send message (same like your old controller)
//   /// Use this if backend expects message via socket.
//   void sendMessageSocket({
//     required String content,
//     String messageType = "text",
//     String? localId,
//   }) {
//     final text = content.trim();
//     if (text.isEmpty) return;

//     final lid = localId ?? DateTime.now().millisecondsSinceEpoch.toString();

//     // stop typing when sending
//     typingStop();

//     socketService.emit(SocketEvents.sendMessage, {
//       "conversationId": conversationId,
//       "content": text,
//       "messageType": messageType,
//       "localId": lid,
//     });
//   }
// }

import 'dart:async';
import 'package:get/get.dart';

import '../../../core/services/socket/socket_events.dart';
import '../../../core/services/socket/socket_service.dart';
import '../models/request/send_message_request_model.dart';
import '../models/responses/send_msg_response_model.dart';
import '../repository/send_message_repository.dart';

/// UI message object (simple) - aap chaaho to apne ChatMessage model se replace kar sakte ho.
class UiMessage {
  final String id; // localId or serverId
  final String content;
  final bool isMe;
  final DateTime createdAt;

  UiMessage({
    required this.id,
    required this.content,
    required this.isMe,
    required this.createdAt,
  });
}

class SendMessageController extends GetxController {
  final SocketService socketService = Get.find<SocketService>();
  final SendMessageRepository repository = SendMessageRepository();

  final RxBool isSending = false.obs;
  final Rxn<SendMessageResponse> lastResponse = Rxn<SendMessageResponse>();

  /// typing indicator local state (for your UI if needed)
  final RxBool isTyping = false.obs;

  late String conversationId;

  /// local message status store
  /// key: localId/serverId, value: sending/sent/delivered/read/failed
  final RxMap<String, String> statusMap = <String, String>{}.obs;

  // Store handlers for proper cleanup
  Function(dynamic)? _deliveredHandler;
  Function(dynamic)? _readHandler;
  Function(dynamic)? _newMessageHandler;

  Timer? _typingDebounce;

  /// Hook: aap apni ChatController.messages me add karna chahte ho to yaha callback de do
  /// e.g. onLocalMessage: (m) => chatController.messages.add(...)
  Function(UiMessage msg)? onLocalMessage;

  void init({
    required String conversationId,
    Function(UiMessage msg)? onLocalMessage,
  }) {
    this.conversationId = conversationId;
    this.onLocalMessage = onLocalMessage;

    _initSocketListeners();
  }

  void _initSocketListeners() {
    socketService.off(SocketEvents.messageDelivered, _deliveredHandler);
    _deliveredHandler = (data) {
      _updateStatusFromReceipt(data, "delivered");
    };
    socketService.on(SocketEvents.messageDelivered, _deliveredHandler!);

    socketService.off(SocketEvents.readReceipt, _readHandler);
    _readHandler = (data) {
      _updateStatusFromReceipt(data, "read");
    };
    socketService.on(SocketEvents.readReceipt, _readHandler!);

    socketService.off(SocketEvents.newMessage, _newMessageHandler);
    _newMessageHandler = (data) {
      if (data is Map) {
        final mid = data["_id"]?.toString();
        final localId = data["localId"]?.toString();

        if (mid != null && mid.isNotEmpty) {
          statusMap[mid] = statusMap[mid] ?? "sent";
        }
        if (localId != null && localId.isNotEmpty) {
          statusMap[localId] = "sent";
        }
      }
    };
    socketService.on(SocketEvents.newMessage, _newMessageHandler!);
  }

  /// typing start (debounced)
  void typingStart() {
    // debounce: user type kar raha hai to repeatedly emit na ho
    _typingDebounce?.cancel();
    if (!isTyping.value) {
      isTyping.value = true;
      socketService.emit(SocketEvents.typingStart, {
        "conversationId": conversationId,
      });
    }

    _typingDebounce = Timer(const Duration(milliseconds: 900), () {
      // user ruk gaya => stop
      typingStop();
    });
  }

  void typingStop() {
    _typingDebounce?.cancel();
    _typingDebounce = null;

    if (isTyping.value) {
      isTyping.value = false;
      socketService.emit(SocketEvents.typingStop, {
        "conversationId": conversationId,
      });
    }
  }

  String statusForId(String id) => statusMap[id] ?? "";

  void _updateStatusFromReceipt(dynamic data, String status) {
    if (data is! Map) return;

    final localId = data["localId"]?.toString();
    final messageId = data["messageId"]?.toString();

    if (messageId != null && messageId.isNotEmpty) {
      statusMap[messageId] = status;
    }
    if (localId != null && localId.isNotEmpty) {
      statusMap[localId] = status;
    }
  }

  /// ✅ HYBRID SEND:
  /// 1) Optimistic UI add (localId)
  /// 2) Socket emit (fast realtime)
  /// 3) REST POST confirm (guaranteed save)
  Future<SendMessageResponse?> sendTextHybrid(String content) async {
    final text = content.trim();
    if (text.isEmpty) return null;

    final localId = DateTime.now().millisecondsSinceEpoch.toString();

    // stop typing when sending
    typingStop();

    // 1) optimistic UI
    statusMap[localId] = "sending";
    onLocalMessage?.call(
      UiMessage(
        id: localId,
        content: text,
        isMe: true,
        createdAt: DateTime.now(),
      ),
    );

    // 2) socket send (fast)
    socketService.emit(SocketEvents.sendMessage, {
      "conversationId": conversationId,
      "content": text,
      "messageType": "text",
      "localId": localId,
    });

    // 3) REST confirm (guarantee)
    isSending.value = true;
    try {
      final req = SendMessageRequest(content: text, messageType: "text");
      final res = await repository.sendMessage(
        conversationId: conversationId,
        request: req,
      );

      lastResponse.value = res;

      // If REST success, mark "sent" at least
      if (res.success == true) {
        statusMap[localId] = "sent";

        // If serverId returned, also store status for serverId
        final serverId = res.data?.id;
        if (serverId != null && serverId.isNotEmpty) {
          statusMap[serverId] = statusMap[serverId] ?? "sent";
        }
      } else {
        statusMap[localId] = "failed";
      }

      return res;
    } catch (_) {
      statusMap[localId] = "failed";
      rethrow;
    } finally {
      isSending.value = false;
    }
  }

  @override
  void onClose() {
    _typingDebounce?.cancel();
    socketService.off(SocketEvents.messageDelivered, _deliveredHandler);
    socketService.off(SocketEvents.readReceipt, _readHandler);
    socketService.off(SocketEvents.newMessage, _newMessageHandler);
    super.onClose();
  }
}
