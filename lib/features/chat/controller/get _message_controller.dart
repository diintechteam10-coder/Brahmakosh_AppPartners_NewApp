// // import 'package:brahmakoshpartners/core/services/socket/socket_service.dart';
// // import 'package:brahmakoshpartners/core/services/socket/socket_events.dart';
// // import 'package:brahmakoshpartners/features/chat/repository/message_repository.dart';
// // import 'package:get/get.dart';

// // class ChatController extends GetxController {
// //   final SocketService socketService = Get.find<SocketService>();
// //   final ChatRepository repository = ChatRepository();

// //   final RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;
// //   final RxBool isTyping = false.obs;

// //   late String conversationId;

// //   @override
// //   void onInit() {
// //     super.onInit();
// //   }

// //   Future<void> initChat({required String conversationId}) async {
// //     this.conversationId = conversationId;

// //     /// OLD HISTORY LOAD
// //     final res = await repository.getMessages(conversationId: conversationId);

// //     if (res is List && res.isNotEmpty) {
// //       messages.assignAll(res.cast<Map<String, dynamic>>());
// //     }

// //     /// JOIN SOCKET
// //     socketService.emit(SocketEvents.joinConversation, {
// //       'conversationId': conversationId,
// //     });

// //     /// LISTEN EVENTS
// //     _initSocketListeners();

// //     /// MARK ALL AS READ ON JOIN
// //     markRead();
// //   }

// //   void _initSocketListeners() {
// //     socketService.off(SocketEvents.newMessage);
// //     socketService.on(SocketEvents.newMessage, (data) {
// //       if (data is Map<String, dynamic>) {
// //         messages.add(data);
// //         markRead(); // Mark as read instantly if user is in chat
// //       }
// //     });

// //     socketService.off(SocketEvents.typingStatus);
// //     socketService.on(SocketEvents.typingStatus, (data) {
// //       if (data is Map && data['isTyping'] != null) {
// //         if (data['conversationId']?.toString() == conversationId) {
// //           isTyping.value = data['isTyping'] == true;
// //         }
// //       }
// //     });

// //     socketService.off(SocketEvents.messageDelivered);
// //     socketService.on(SocketEvents.messageDelivered, (data) {
// //       _updateMessageStatus(data, 'delivered');
// //     });

// //     socketService.off(SocketEvents.readReceipt);
// //     socketService.on(SocketEvents.readReceipt, (data) {
// //       _updateMessageStatus(data, 'read');
// //     });
// //   }

// //   void _updateMessageStatus(dynamic data, String newStatus) {
// //     if (data is Map) {
// //       final localId = data['localId']?.toString();
// //       final messageId = data['messageId']?.toString();

// //       final index = messages.indexWhere(
// //         (m) =>
// //             (localId != null && m['localId']?.toString() == localId) ||
// //             (messageId != null && m['_id']?.toString() == messageId) ||
// //             (messageId != null && m['messageId']?.toString() == messageId),
// //       );

// //       if (index != -1) {
// //         final updatedMsg = Map<String, dynamic>.from(messages[index]);
// //         updatedMsg['status'] = newStatus;
// //         messages[index] = updatedMsg;
// //       }
// //     }
// //   }

// //   // ================= SEND TEXT =================
// //   void sendText(String text) {
// //     final localId = DateTime.now().millisecondsSinceEpoch.toString();

// //     /// instant UI
// //     messages.add({
// //       "localId": localId,
// //       "content": text,
// //       "senderRole": "partner",
// //       "status": "sending",
// //     });

// //     /// server send
// //     socketService.emit(SocketEvents.sendMessage, {
// //       "conversationId": conversationId,
// //       "content": text,
// //       "localId": localId,
// //     });
// //   }

// //   // ================= READ RECEIPT =================
// //   void markRead() {
// //     socketService.emit(SocketEvents.messageRead, {
// //       'conversationId': conversationId,
// //     });
// //   }

// //   // ================= TYPING =================
// //   void typingStart() => socketService.emit(SocketEvents.typingStart, {
// //     'conversationId': conversationId,
// //   });

// //   void typingStop() => socketService.emit(SocketEvents.typingStop, {
// //     'conversationId': conversationId,
// //   });

// //   @override
// //   void onClose() {
// //     socketService.emit(SocketEvents.leaveConversation, {
// //       'conversationId': conversationId,
// //     });
// //     socketService.off(SocketEvents.newMessage);
// //     socketService.off(SocketEvents.typingStatus);
// //     socketService.off(SocketEvents.messageDelivered);
// //     socketService.off(SocketEvents.readReceipt);
// //     super.onClose();
// //   }
// // }

// import 'package:brahmakoshpartners/core/services/socket/socket_events.dart';
// import 'package:brahmakoshpartners/core/services/socket/socket_service.dart';
// import 'package:flutter/foundation.dart';
// import 'package:brahmakoshpartners/features/chat/repository/get_message_repository.dart';
// import 'package:get/get.dart';

// import '../models/responses/users_message_response_model.dart';

// class GetMessageController extends GetxController {
//   final SocketService socketService = Get.find<SocketService>();
//   final ChatRepository repository = ChatRepository();

//   /// Now typed list
//   final RxList<ChatMessage> messages = <ChatMessage>[].obs;

//   final RxBool isTyping = false.obs;

//   /// Optional extras from response
//   final RxString conversationStatus = ''.obs;
//   final RxBool isAccepted = false.obs;

//   late String conversationId;

//   @override
//   void onInit() {
//     super.onInit();
//   }

//   Future<void> initChat({required String conversationId}) async {
//     this.conversationId = conversationId;

//     // ✅ REST history load (your response: {success:true, data:{messages:[...]}})
//     final ChatMessagesResponse res = await repository.getMessages(
//       conversationId: conversationId,
//     );

//     final list = res.data?.messages ?? <ChatMessage>[];
//     messages.assignAll(list);

//     conversationStatus.value = res.data?.conversationStatus ?? '';
//     isAccepted.value = res.data?.isAccepted ?? false;

//     /// JOIN SOCKET
//     if (socketService.isConnected) {
//       debugPrint(
//         "🔵 Socket is connected. Joining conversation: $conversationId",
//       );
//       socketService.emit(SocketEvents.joinConversation, {
//         'conversationId': conversationId,
//       });
//     } else {
//       debugPrint("🔴 Socket is NOT connected. Attempting to connect...");
//       // Optionally trigger connect here if you have the token
//       // or listen to connection stream to join once connected
//       socketService.connected$.listen((connected) {
//         if (connected) {
//           debugPrint(
//             "🟢 Socket Reconnected. Joining conversation: $conversationId",
//           );
//           socketService.emit(SocketEvents.joinConversation, {
//             'conversationId': conversationId,
//           });
//         }
//       });
//     }

//     /// LISTEN EVENTS
//     _initSocketListeners();

//     /// MARK ALL AS READ ON JOIN
//     markRead();
//   }

//   void _initSocketListeners() {
//     debugPrint(
//       "🎧 Initializing Socket Listeners for Conversation: $conversationId",
//     );

//     // Don't remove global listeners if possible, but for this controller we want to ensure we catch events
//     socketService.off(SocketEvents.newMessage);

//     socketService.on(SocketEvents.newMessage, (data) {
//       debugPrint("📩 MESSAGE RECEIVED (Raw): $data");

//       if (data is Map) {
//         final mapData = Map<String, dynamic>.from(data);

//         // Filter by conversationId if possible to avoid cross-talk?
//         // Usually the server only sends to the room, so this is implicit.

//         final msg = _messageFromSocket(mapData);
//         debugPrint("🧩 Parsed Message: ${msg.content} (ID: ${msg.id})");

//         // Check deduplication
//         final existingIndex = messages.indexWhere((m) {
//           // 1. Server ID match
//           if (m.id.isNotEmpty && m.id == msg.id) return true;

//           // 2. Local ID match
//           final localId = mapData['localId']?.toString();
//           if (localId != null && m.id == localId) return true;

//           return false;
//         });

//         if (existingIndex != -1) {
//           debugPrint("🔄 Updating existing message at index $existingIndex");
//           messages[existingIndex] = msg;
//         } else {
//           // Fuzzy match fallback
//           final fuzzyIndex = messages.indexWhere(
//             (m) =>
//                 m.content == msg.content &&
//                 m.senderModel == msg.senderModel &&
//                 m.createdAt!.difference(msg.createdAt!).inSeconds.abs() < 5,
//           ); // Increased window

//           if (fuzzyIndex != -1) {
//             debugPrint("🔄 Fuzzy match update at index $fuzzyIndex");
//             messages[fuzzyIndex] = msg;
//           } else {
//             debugPrint("➕ Adding NEW message to list");
//             messages.add(msg);
//           }
//         }

//         // Force UI refresh if needed (Obx should handle it, but messages.refresh() helps)
//         messages.refresh();
//         markRead();
//       } else {
//         debugPrint("⚠️ Received newMessage but data was not a Map: $data");
//       }
//     });

//     socketService.off(SocketEvents.typingStatus);
//     socketService.on(SocketEvents.typingStatus, (data) {
//       if (data is Map && data['isTyping'] != null) {
//         if (data['conversationId']?.toString() == conversationId) {
//           isTyping.value = data['isTyping'] == true;
//         }
//       }
//     });

//     socketService.off(SocketEvents.messageDelivered);
//     socketService.on(SocketEvents.messageDelivered, (data) {
//       _updateMessageStatus(data, 'delivered');
//     });

//     socketService.off(SocketEvents.readReceipt);
//     socketService.on(SocketEvents.readReceipt, (data) {
//       _updateMessageStatus(data, 'read');
//     });
//   }

//   /// Convert socket payload -> ChatMessage
//   /// (supports both full server message & lightweight local message)
//   ChatMessage _messageFromSocket(Map<String, dynamic> data) {
//     // If server sends full message with _id
//     if (data.containsKey('_id')) {
//       return ChatMessage.fromJson(data);
//     }

//     // Otherwise build a minimal message for UI
//     return ChatMessage(
//       id: data['messageId']?.toString() ?? data['localId']?.toString() ?? '',
//       conversationId: data['conversationId']?.toString(),
//       senderId: Sender.fromJson(
//         (data['senderId'] is Map<String, dynamic>)
//             ? data['senderId'] as Map<String, dynamic>
//             : <String, dynamic>{
//                 "_id": data['senderId']?.toString() ?? '',
//                 "name": data['senderRole']?.toString(),
//               },
//       ),
//       senderModel:
//           data['senderModel']?.toString() ??
//           (data['senderRole']?.toString().toLowerCase() == 'partner'
//               ? 'Partner'
//               : 'User'),
//       receiverId: data['receiverId']?.toString(),
//       receiverModel: data['receiverModel']?.toString(),
//       messageType: data['messageType']?.toString() ?? 'text',
//       content: data['content']?.toString() ?? '', // ✅ Ensure not null
//       mediaUrl: data['mediaUrl']?.toString(),
//       isRead: data['isRead'] == true,
//       readAt: _tryParseDate(data['readAt']),
//       isDelivered: data['isDelivered'] == true,
//       deliveredAt: _tryParseDate(data['deliveredAt']),
//       isDeleted: data['isDeleted'] == true,
//       deletedAt: _tryParseDate(data['deletedAt']),
//       createdAt: _tryParseDate(data['createdAt']) ?? DateTime.now(),
//       updatedAt: _tryParseDate(data['updatedAt']) ?? DateTime.now(),
//       v: (data['__v'] as num?)?.toInt(),
//     );
//   }

//   void _updateMessageStatus(dynamic data, String newStatus) {
//     if (data is! Map) return;

//     final localId = data['localId']?.toString();
//     final messageId = data['messageId']?.toString();

//     final index = messages.indexWhere((m) {
//       final mId = m.id;
//       // We don't have localId in ChatMessage explicitly unless it's the ID.
//       // But usually for local messages id==localId.
//       return (localId != null && mId == localId) ||
//           (messageId != null && mId == messageId);
//     });

//     if (index == -1) return;

//     final oldMsg = messages[index];
//     ChatMessage newMsg;

//     if (newStatus == 'read') {
//       newMsg = oldMsg.copyWith(isRead: true, readAt: DateTime.now());
//     } else if (newStatus == 'delivered') {
//       newMsg = oldMsg.copyWith(isDelivered: true, deliveredAt: DateTime.now());
//     } else {
//       newMsg = oldMsg;
//     }

//     messages[index] = newMsg; // ✅ Updates UI automatically
//     messages.refresh();
//   }

//   /// ✅ Track local status without changing backend model
//   final Map<String, String> _messageStatus = {};

//   String statusFor(ChatMessage m) => _messageStatus[m.id] ?? '';

//   // ================= SEND TEXT =================
//   void sendText(String text) {
//     final localId = DateTime.now().millisecondsSinceEpoch.toString();

//     // Local optimistic message (id = localId)
//     final localMsg = ChatMessage(
//       id: localId,
//       conversationId: conversationId,
//       senderId: Sender(
//         id: 'me',
//         name: 'partner',
//         email: null,
//         profilePicture: null,
//         profile: null,
//       ),
//       senderModel: 'Partner',
//       receiverId: null,
//       receiverModel: 'User',
//       messageType: 'text',
//       content: text,
//       mediaUrl: null,
//       isRead: false,
//       readAt: null,
//       isDelivered: false,
//       deliveredAt: null,
//       isDeleted: false,
//       deletedAt: null,
//       createdAt: DateTime.now(),
//       updatedAt: DateTime.now(),
//       v: 0,
//     );

//     messages.add(localMsg);
//     _messageStatus[localId] = 'sending';

//     socketService.emit(SocketEvents.sendMessage, {
//       "conversationId": conversationId,
//       "content": text,
//       "localId": localId,
//       "messageType": "text",
//     });
//   }

//   // ================= READ RECEIPT =================
//   void markRead() {
//     socketService.emit(SocketEvents.messageRead, {
//       'conversationId': conversationId,
//     });
//   }

//   // ================= TYPING =================
//   void typingStart() => socketService.emit(SocketEvents.typingStart, {
//     'conversationId': conversationId,
//   });

//   void typingStop() => socketService.emit(SocketEvents.typingStop, {
//     'conversationId': conversationId,
//   });

//   void leaveChat() {
//     if (conversationId.isNotEmpty) {
//       // socketService.leaveConversation(conversationId); // use helper if available
//       socketService.emit(SocketEvents.leaveConversation, {
//         'conversationId': conversationId,
//       });

//       socketService.off(SocketEvents.newMessage);
//       socketService.off(SocketEvents.typingStatus);
//       socketService.off(SocketEvents.messageDelivered);
//       socketService.off(SocketEvents.readReceipt);
//       conversationId = '';
//     }
//   }

//   @override
//   void onClose() {
//     leaveChat();
//     super.onClose();
//   }
// }

// /// Same helper used in model file (keep one copy in your project)
// DateTime? _tryParseDate(dynamic value) {
//   if (value == null) return null;
//   if (value is DateTime) return value;
//   if (value is String) {
//     try {
//       return DateTime.parse(value);
//     } catch (_) {
//       return null;
//     }
//   }
//   return null;
// }

// ================= get_message_controller.dart =================
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:brahmakoshpartners/core/services/socket/socket_events.dart';
import 'package:brahmakoshpartners/core/services/socket/socket_service.dart';
import '../models/responses/users_message_response_model.dart';
import '../repository/get_message_repository.dart';

class GetMessageController extends GetxController {
  final SocketService socketService = Get.find<SocketService>();
  final ChatRepository repository = ChatRepository();

  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxBool isTyping = false.obs;

  final RxString conversationStatus = ''.obs;
  final RxBool isAccepted = false.obs;
  final Rxn<DateTime> acceptedAt = Rxn<DateTime>();

  late String conversationId;

  // Store handlers for proper cleanup
  Function(dynamic)? _newMessageHandler;
  Function(dynamic)? _typingHandler;
  Function(dynamic)? _deliveredHandler;
  Function(dynamic)? _readHandler;

  Future<void> initChat({required String conversationId}) async {
    this.conversationId = conversationId;

    // ✅ REST history load
    final ChatMessagesResponse res = await repository.getMessages(
      conversationId: conversationId,
    );
    print(
      "🔄🔄🔄 [GET_MSG_CTRL] initChat Response: ${res.success}, Data: ${res.data != null}",
    );
    if (res.data != null) {
      print(
        "🔄🔄🔄 [GET_MSG_CTRL] initChat Status: ${res.data?.conversationStatus}",
      );
      print(
        "🔄🔄🔄 [GET_MSG_CTRL] initChat SessionDetails: ${res.data?.sessionDetails?.toJson()}",
      );
    }

    final list = res.data?.messages ?? <ChatMessage>[];
    messages.assignAll(_deduplicateMessages(list));

    conversationStatus.value = res.data?.conversationStatus ?? '';
    isAccepted.value = res.data?.isAccepted ?? false;
    acceptedAt.value = res.data?.sessionDetails?.startTime;
    print(
      "🔄🔄🔄 [GET_MSG_CTRL] initChat for $conversationId - status: ${conversationStatus.value}, acceptedAt: ${acceptedAt.value}",
    );

    // ✅ JOIN ROOM
    socketService.emit(SocketEvents.joinConversation, {
      'conversationId': conversationId,
    });

    // ✅ LISTEN
    _initSocketListeners();

    // ✅ MARK READ
    markRead();
  }

  Future<void> refreshMessages() async {
    if (conversationId.isNotEmpty) {
      debugPrint("🔄 Refreshing messages for $conversationId");
      await initChat(conversationId: conversationId);
    }
  }

  void _initSocketListeners() {
    // ------------- NEW MESSAGE (FIXED) -------------
    socketService.off(SocketEvents.newMessage, _newMessageHandler);
    _newMessageHandler = (data) {
      debugPrint("📩 NEW MESSAGE EVENT: $data");

      if (data is! Map) return;
      final root = Map<String, dynamic>.from(data);

      final msgMap = (root['message'] is Map)
          ? Map<String, dynamic>.from(root['message'])
          : root;

      final incomingConvId = msgMap['conversationId']?.toString();
      if (incomingConvId == null || incomingConvId != conversationId) {
        return;
      }

      final msg = _messageFromSocket(msgMap);
      if ((msg.content ?? '').trim().isEmpty) return;

      // ✅ Deduplication Strategy:
      final idx = messages.indexWhere((m) {
        // 1. Match by Server ID
        if (m.id.isNotEmpty && msg.id.isNotEmpty && m.id == msg.id) {
          debugPrint("🎯 Match by Server ID: ${m.id}");
          return true;
        }

        // 2. Match by Local ID (m.localId or m.id if it was used as localId)
        final incomingLocalId = msg.localId ?? msgMap['localId']?.toString();
        if (incomingLocalId != null && incomingLocalId.isNotEmpty) {
          if (m.localId == incomingLocalId || m.id == incomingLocalId) {
            debugPrint("🎯 Match by Local ID: $incomingLocalId");
            return true;
          }
        }

        // 3. Fallback: Robust Content-based Match for Partner messages
        // If we (Partner) sent it, and server reflects it back without matching IDs,
        // we check content + sender role + recent timestamp.
        if (msg.senderModel?.toLowerCase() == 'partner' &&
            m.senderModel?.toLowerCase() == 'partner') {
          final contentMatch =
              (m.content ?? '').trim() == (msg.content ?? '').trim();
          if (contentMatch) {
            final timeDiff = (m.createdAt != null && msg.createdAt != null)
                ? (m.createdAt!.difference(msg.createdAt!).inSeconds.abs())
                : 999;
            if (timeDiff < 30) {
              debugPrint("🎯 Match by Content Fallback (diff: ${timeDiff}s)");
              return true;
            }
          }
        }

        return false;
      });

      if (idx != -1) {
        debugPrint("🔄 Updating/Merging existing message at index $idx");
        messages[idx] = _mergeMessages(messages[idx], msg);
      } else {
        debugPrint("➕ Adding NEW message: ${msg.id} / ${msg.localId}");
        messages.add(msg);
      }

      messages.refresh();
      markRead();
    };
    socketService.on(SocketEvents.newMessage, _newMessageHandler!);

    // ------------- TYPING -------------
    socketService.off(SocketEvents.typingStatus, _typingHandler);
    _typingHandler = (data) {
      if (data is Map && data['isTyping'] != null) {
        if (data['conversationId']?.toString() == conversationId) {
          isTyping.value = data['isTyping'] == true;
        }
      }
    };
    socketService.on(SocketEvents.typingStatus, _typingHandler!);

    socketService.off(SocketEvents.messageDelivered, _deliveredHandler);
    _deliveredHandler = (data) {
      _updateMessageStatus(data, 'delivered');
    };
    socketService.on(SocketEvents.messageDelivered, _deliveredHandler!);

    socketService.off(SocketEvents.readReceipt, _readHandler);
    _readHandler = (data) {
      _updateMessageStatus(data, 'read');
    };
    socketService.on(SocketEvents.readReceipt, _readHandler!);
  }

  /// ✅ Robust Merge: Combine two message versions (one might be more complete than other)
  ChatMessage _mergeMessages(ChatMessage oldMsg, ChatMessage newMsg) {
    // Determine which status to keep (highest status wins)
    bool isRead = oldMsg.isRead || newMsg.isRead;
    bool isDelivered = oldMsg.isDelivered || newMsg.isDelivered;

    return newMsg.copyWith(
      id: (newMsg.id.isNotEmpty) ? newMsg.id : oldMsg.id,
      localId: newMsg.localId ?? oldMsg.localId,
      isRead: isRead,
      isDelivered: isDelivered,
      readAt: newMsg.readAt ?? oldMsg.readAt,
      deliveredAt: newMsg.deliveredAt ?? oldMsg.deliveredAt,
      createdAt: oldMsg.createdAt ?? newMsg.createdAt,
    );
  }

  /// ✅ List-wide deduplication for History Load
  List<ChatMessage> _deduplicateMessages(List<ChatMessage> incoming) {
    if (incoming.isEmpty) return [];

    final List<ChatMessage> result = [];

    for (final item in incoming) {
      final idx = result.indexWhere((m) {
        // 1. Exact Server ID
        if (m.id.isNotEmpty && item.id.isNotEmpty && m.id == item.id)
          return true;
        // 2. Exact Local ID
        if (m.localId != null &&
            item.localId != null &&
            m.localId == item.localId)
          return true;
        // 3. Cross ID (serverId matches someone's localId)
        if (item.id.isNotEmpty && m.localId == item.id) return true;
        if (m.id.isNotEmpty && item.localId == m.id) return true;
        // 4. Content Fallback
        if (m.senderModel?.toLowerCase() == 'partner' &&
            item.senderModel?.toLowerCase() == 'partner') {
          if ((m.content ?? '').trim() == (item.content ?? '').trim()) {
            final diff = (m.createdAt != null && item.createdAt != null)
                ? m.createdAt!.difference(item.createdAt!).inSeconds.abs()
                : 999;
            if (diff < 10) return true;
          }
        }
        return false;
      });

      if (idx != -1) {
        result[idx] = _mergeMessages(result[idx], item);
      } else {
        result.add(item);
      }
    }

    return result;
  }

  /// ✅ robust parse
  ChatMessage _messageFromSocket(Map<String, dynamic> data) {
    // In case someone passes root accidentally
    if (data.containsKey('message') && data['message'] is Map) {
      data = Map<String, dynamic>.from(data['message']);
    }

    // Server full msg has _id
    if (data.containsKey('_id')) {
      return ChatMessage.fromJson(data);
    }

    // Fallback minimal
    return ChatMessage(
      id:
          data['_id']?.toString() ??
          data['messageId']?.toString() ??
          data['localId']?.toString() ??
          '',
      conversationId: data['conversationId']?.toString(),
      senderId: Sender.fromJson(
        (data['senderId'] is Map<String, dynamic>)
            ? data['senderId'] as Map<String, dynamic>
            : <String, dynamic>{
                "_id": data['senderId']?.toString() ?? '',
                "name": data['senderModel']?.toString(),
              },
      ),
      senderModel: data['senderModel']?.toString(),
      receiverId: data['receiverId']?.toString(),
      receiverModel: data['receiverModel']?.toString(),
      messageType: data['messageType']?.toString() ?? 'text',
      content: data['content']?.toString() ?? '',
      mediaUrl: data['mediaUrl']?.toString(),
      isRead: data['isRead'] == true,
      readAt: _tryParseDate(data['readAt']),
      isDelivered: data['isDelivered'] == true,
      deliveredAt: _tryParseDate(data['deliveredAt']),
      isDeleted: data['isDeleted'] == true,
      deletedAt: _tryParseDate(data['deletedAt']),
      localId: data['localId']?.toString(),
      createdAt: _tryParseDate(data['createdAt']) ?? DateTime.now(),
      updatedAt: _tryParseDate(data['updatedAt']) ?? DateTime.now(),
      v: (data['__v'] as num?)?.toInt(),
    );
  }

  void _updateMessageStatus(dynamic data, String newStatus) {
    if (data is! Map) return;

    final map = Map<String, dynamic>.from(data);
    final localId = map['localId']?.toString();
    final messageId = map['messageId']?.toString();

    final index = messages.indexWhere((m) {
      // Check serverId
      if (messageId != null && messageId.isNotEmpty && m.id == messageId)
        return true;
      // Check localId
      if (localId != null && localId.isNotEmpty) {
        if (m.localId == localId) return true;
        if (m.id == localId) return true; // fallback for older local msgs
      }
      return false;
    });

    if (index == -1) return;

    final oldMsg = messages[index];
    ChatMessage newMsg;

    if (newStatus == 'read') {
      newMsg = oldMsg.copyWith(isRead: true, readAt: DateTime.now());
    } else if (newStatus == 'delivered') {
      newMsg = oldMsg.copyWith(isDelivered: true, deliveredAt: DateTime.now());
    } else {
      newMsg = oldMsg;
    }

    messages[index] = newMsg;
    messages.refresh();
  }

  void markRead() {
    socketService.emit(SocketEvents.messageRead, {
      'conversationId': conversationId,
    });
  }

  void typingStart() => socketService.emit(SocketEvents.typingStart, {
    'conversationId': conversationId,
  });

  void typingStop() => socketService.emit(SocketEvents.typingStop, {
    'conversationId': conversationId,
  });

  void leaveChat() {
    if (conversationId.isNotEmpty) {
      socketService.emit(SocketEvents.leaveConversation, {
        'conversationId': conversationId,
      });

      socketService.off(SocketEvents.newMessage, _newMessageHandler);
      socketService.off(SocketEvents.typingStatus, _typingHandler);
      socketService.off(SocketEvents.messageDelivered, _deliveredHandler);
      socketService.off(SocketEvents.readReceipt, _readHandler);

      conversationId = '';
    }
  }

  @override
  void onClose() {
    leaveChat();
    super.onClose();
  }
}

DateTime? _tryParseDate(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  if (value is String) {
    try {
      return DateTime.parse(value);
    } catch (_) {
      return null;
    }
  }
  return null;
}
