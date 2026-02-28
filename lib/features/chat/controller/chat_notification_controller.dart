import 'package:brahmakoshpartners/core/services/socket/socket_events.dart';
import 'package:brahmakoshpartners/core/services/socket/socket_service.dart';
import 'package:brahmakoshpartners/features/chat/controller/get _message_controller.dart';
import 'package:brahmakoshpartners/features/conversations/repository/conversation_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class ChatNotification {
  final String conversationId;
  final String senderName;
  final String lastMessage;
  final int unreadCount;
  final String? profilePic;
  final DateTime? acceptedAt;

  ChatNotification({
    required this.conversationId,
    required this.senderName,
    required this.lastMessage,
    required this.unreadCount,
    this.profilePic,
    this.acceptedAt,
  });
}

class ChatNotificationController extends GetxController {
  final SocketService _socketService = Get.find<SocketService>();

  // Observable for the current notification being shown
  final Rxn<ChatNotification> currentBanner = Rxn<ChatNotification>();

  // Track unread counts for non-active chats to show in notification
  final RxMap<String, int> _unreadCounts = <String, int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    debugPrint("🔔 ChatNotificationController: ON_INIT");
    _initSocketListeners();
    _syncAndJoinRooms();

    // Listen for reconnection to re-join rooms
    _socketService.connected$.listen((connected) {
      if (connected) {
        debugPrint(
          "🔔 ChatNotificationController: Socket Reconnected, re-syncing rooms",
        );
        _syncAndJoinRooms();
      }
    });
  }

  Future<void> _syncAndJoinRooms() async {
    try {
      debugPrint(
        "🔔 ChatNotificationController: Syncing active conversations for room joining...",
      );
      final repo = ConversationRepository();
      // Fetch both accepted and active just in case
      final res = await repo.getConversations(status: "accepted");

      List convs = [];
      if (res is Map && res['data'] is List) {
        convs = res['data'];
      } else if (res is List) {
        convs = res;
      }

      debugPrint(
        "🔔 ChatNotificationController: Found ${convs.length} conversations to join",
      );

      for (var c in convs) {
        final id = c['conversationId']?.toString() ?? c['_id']?.toString();
        if (id != null) {
          debugPrint("🔔 ChatNotificationController: Joining room: $id");
          _socketService.emit(SocketEvents.joinConversation, {
            'conversationId': id,
          });
        }
      }
    } catch (e) {
      debugPrint("🔔 ChatNotificationController: Error syncing rooms: $e");
    }
  }

  void _initSocketListeners() {
    debugPrint("🔔 ChatNotificationController: Initializing Socket Listeners");

    // Also listen for new conversation requests
    _socketService.on(SocketEvents.newConversationRequest, (data) {
      debugPrint(
        "🔔 ChatNotificationController: Received newConversationRequest: $data",
      );
    });

    _socketService.on(SocketEvents.newMessage, (data) {
      debugPrint(
        "🔔 ChatNotificationController: Received newMessage event: $data",
      );
      if (data is! Map) {
        debugPrint("🔔 ChatNotificationController: Data is not a Map");
        return;
      }
      final root = Map<String, dynamic>.from(data);
      final msgMap = (root['message'] is Map)
          ? Map<String, dynamic>.from(root['message'])
          : root;

      final convId = msgMap['conversationId']?.toString();
      final senderRole =
          msgMap['senderRole']?.toString() ??
          msgMap['senderType']?.toString() ??
          msgMap['senderModel']?.toString();

      debugPrint(
        "🔔 ChatNotificationController: convId: $convId, senderRole: $senderRole",
      );

      if (convId == null || senderRole?.toLowerCase() != 'user') {
        debugPrint(
          "🔔 ChatNotificationController: Skipping (convId null or sender not user)",
        );
        return;
      }

      // Check if we are currently in this chat
      bool isInThisChat = false;
      try {
        // 1. Check if the current route is chat screen
        if (Get.currentRoute == '/chatScreen') {
          final args = Get.arguments;
          if (args is Map && args['conversationId']?.toString() == convId) {
            isInThisChat = true;
          }
        }

        // 2. Fallback check via controller registration (less reliable for tagging)
        if (!isInThisChat && Get.isRegistered<GetMessageController>()) {
          final chatCtrl = Get.find<GetMessageController>();
          if (chatCtrl.conversationId == convId) {
            isInThisChat = true;
          }
        }

        // 3. Precise check with tag
        if (!isInThisChat &&
            Get.isRegistered<GetMessageController>(tag: convId)) {
          isInThisChat = true;
        }
      } catch (e) {
        debugPrint(
          "🔔 ChatNotificationController: Could not check current chat status: $e",
        );
      }

      if (isInThisChat) {
        debugPrint(
          "🔔 ChatNotificationController: User is in this chat ($convId), skipping banner",
        );
      } else {
        debugPrint(
          "🔔 ChatNotificationController: TRIGGERING BANNER for $convId",
        );
        _handleIncomingNotification(convId, msgMap);
      }
    });
  }

  void _handleIncomingNotification(String convId, Map<String, dynamic> msgMap) {
    debugPrint(
      "🔔 ChatNotificationController: Processing notification for $convId",
    );
    // Update unread count
    _unreadCounts[convId] = (_unreadCounts[convId] ?? 0) + 1;

    // Extract info
    String senderName = 'User';
    String? profilePic;

    // Try to get sender info from message or from extras if provided
    if (msgMap['senderDetails'] is Map) {
      final details = msgMap['senderDetails'];
      senderName = details['name']?.toString() ?? 'User';
      profilePic = details['profileImage']?.toString();
    } else if (msgMap['senderId'] is Map) {
      final s = msgMap['senderId'];
      senderName = s['name']?.toString() ?? 'User';
      if (s['profile'] is Map) {
        senderName = s['profile']['name']?.toString() ?? senderName;
      }
    }

    final content = msgMap['content']?.toString() ?? '';
    debugPrint(
      "🔔 ChatNotificationController: Sender: $senderName, Content: $content",
    );

    currentBanner.value = ChatNotification(
      conversationId: convId,
      senderName: senderName,
      lastMessage: content,
      unreadCount: _unreadCounts[convId]!,
      profilePic: profilePic,
      acceptedAt: _tryParseDate(msgMap['acceptedAt']),
    );

    // Auto hide after some time if not already hidden
    Future.delayed(const Duration(seconds: 5), () {
      if (currentBanner.value?.conversationId == convId) {
        debugPrint(
          "🔔 ChatNotificationController: Auto-hiding banner for $convId",
        );
        currentBanner.value = null;
      }
    });
  }

  void clearNotification(String convId) {
    _unreadCounts.remove(convId);
    if (currentBanner.value?.conversationId == convId) {
      currentBanner.value = null;
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
}
