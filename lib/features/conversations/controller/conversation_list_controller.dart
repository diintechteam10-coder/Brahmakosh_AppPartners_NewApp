// import 'package:brahmakoshpartners/core/errors/exception.dart';
// import 'package:brahmakoshpartners/core/services/socket/socket_service.dart';
// import 'package:brahmakoshpartners/core/services/socket/socket_events.dart';
// import 'package:brahmakoshpartners/features/conversations/repository/conversation_repository.dart';
// import 'package:get/get.dart';

// class ConversationController extends GetxController {
//   final ConversationRepository repository = ConversationRepository();
//   final SocketService _socket = Get.find<SocketService>();

//   RxBool isLoading = false.obs;
//   RxList<Map<String, dynamic>> conversations = <Map<String, dynamic>>[].obs;

//   @override
//   void onInit() {
//     super.onInit();
//     _initSocketListeners();
//   }

//   void _initSocketListeners() {
//     _socket.on(SocketEvents.newMessage, (data) {
//       if (data is Map<String, dynamic>) {
//         _handleNewMessage(data);
//       }
//     });

//     _socket.on(SocketEvents.newConversationRequest, (data) {
//       // Refresh pending list or add new request
//       fetchConversations(status: "pending");
//     });

//     _socket.on(SocketEvents.readReceipt, (data) {
//       if (data is Map<String, dynamic>) {
//         _handleReadReceipt(data);
//       }
//     });

//     _socket.on(SocketEvents.partnerStatusChanged, (data) {
//       // Optional: Handle if you need to sync UI state
//     });
//   }

//   void _handleNewMessage(Map<String, dynamic> data) {
//     final convId = data['conversationId']?.toString();
//     if (convId == null) return;

//     final index = conversations.indexWhere(
//       (c) =>
//           (c['conversationId']?.toString() == convId) ||
//           (c['_id']?.toString() == convId),
//     );

//     if (index != -1) {
//       final updatedConv = Map<String, dynamic>.from(conversations[index]);
//       updatedConv['lastMessage'] = data;
//       updatedConv['updatedAt'] =
//           data['createdAt'] ?? DateTime.now().toIso8601String();

//       // Increment unread count if it's from user
//       if (data['senderRole'] == 'user' || data['senderType'] == 'user') {
//         updatedConv['unreadCount'] = (updatedConv['unreadCount'] ?? 0) + 1;
//       }

//       conversations.removeAt(index);
//       conversations.insert(0, updatedConv);
//     } else {
//       // New conversation or not in current list view, maybe refetch?
//       fetchConversations();
//     }
//   }

//   void _handleReadReceipt(Map<String, dynamic> data) {
//     final convId = data['conversationId']?.toString();
//     if (convId == null) return;

//     final index = conversations.indexWhere(
//       (c) =>
//           (c['conversationId']?.toString() == convId) ||
//           (c['_id']?.toString() == convId),
//     );

//     if (index != -1) {
//       final updatedConv = Map<String, dynamic>.from(conversations[index]);
//       updatedConv['unreadCount'] = 0;
//       conversations[index] = updatedConv;
//     }
//   }

//   List _extractList(dynamic response) {
//     if (response is Map<String, dynamic>) {
//       final data = response['data'];
//       if (data is Map && data['conversations'] is List) {
//         return data['conversations'] as List;
//       }
//       if (data is List) return data;
//       if (response['conversations'] is List) {
//         return response['conversations'] as List;
//       }
//     }
//     if (response is List) return response;
//     return <dynamic>[];
//   }

//   Future<bool?> fetchConversations({String? status}) async {
//     isLoading.value = true;
//     try {
//       final res = await repository.getConversations(status: status);
//       final list = _extractList(res);
//       conversations.assignAll(list.cast<Map<String, dynamic>>());
//       return true;
//     } on NoInternetException {
//       Get.snackbar("No Internet !", "Internet connection not available");
//       return false;
//     } on ApiException catch (e) {
//       Get.snackbar("Error !", e.message);
//       return false;
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   @override
//   void onClose() {
//     _socket.off(SocketEvents.newMessage);
//     _socket.off(SocketEvents.newConversationRequest);
//     _socket.off(SocketEvents.readReceipt);
//     _socket.off(SocketEvents.partnerStatusChanged);
//     super.onClose();
//   }
// }

// conversation_controller.dart

import 'package:brahmakoshpartners/core/errors/exception.dart';
import 'package:brahmakoshpartners/core/services/socket/socket_events.dart';
import 'package:brahmakoshpartners/core/services/socket/socket_service.dart';
import 'package:brahmakoshpartners/features/conversations/repository/conversation_repository.dart';
import 'package:brahmakoshpartners/features/home/repository/home_repository.dart'; // ✅ Import
import 'package:brahmakoshpartners/features/conversations/controller/get_unread_count_controller.dart'; // ✅ Import
import 'package:get/get.dart';

class ConversationController extends GetxController {
  final ConversationRepository repository = ConversationRepository();
  final HomeRepository _homeRepository =
      HomeRepository(); // ✅ For status update
  final SocketService _socket = Get.find<SocketService>();

  RxBool isLoading = false.obs;
  RxList<Map<String, dynamic>> conversations = <Map<String, dynamic>>[].obs;
  RxString currentStatus = 'online'.obs; // ✅ Track status

  RxString _currentFilterStatus = RxString(''); // Track current filter

  @override
  void onInit() {
    super.onInit();
    _initSocketListeners();
  }

  void _initSocketListeners() {
    _socket.on(SocketEvents.newMessage, (data) {
      if (data is Map<String, dynamic>) {
        _handleNewMessage(data);
      }
    });

    _socket.on(SocketEvents.newConversationRequest, (data) {
      // Refresh current list instead of forcing "pending"
      // If user is on "Active" tab, they won't lose their view.
      // If user is on "Pending" tab, they will see the new request.
      fetchConversations(status: _currentFilterStatus.value);
    });

    _socket.on(SocketEvents.readReceipt, (data) {
      if (data is Map<String, dynamic>) {
        _handleReadReceipt(data);
      }
    });

    _socket.on(SocketEvents.partnerStatusChanged, (data) {
      if (data is Map && data['status'] != null) {
        currentStatus.value = data['status'].toString();
      }
    });

    _socket.on(SocketEvents.conversationEnded, (data) {
      if (data is Map<String, dynamic>) {
        _handleConversationEnded(data);
      }
    });
  }

  void _checkConcurrency() {
    // Count active conversations
    final activeCount = conversations.where((c) {
      final s = c['status']?.toString().toLowerCase();
      // Adjust based on your actual API status values for active chats
      return s == 'active' || s == 'accepted';
    }).length;

    if (activeCount >= 5) {
      if (currentStatus.value != 'busy') {
        _homeRepository.updatePartnerStatus(status: 'busy').then((_) {
          currentStatus.value = 'busy';
          Get.snackbar(
            "Busy Mode",
            "You reached 5 active chats. Status set to Busy.",
          );
        });
      }
    } else {
      // If capacity is available AND we are currently 'busy', revert to 'online'
      // We avoid switching from 'offline' -> 'online' automatically
      if (currentStatus.value == 'busy') {
        _homeRepository.updatePartnerStatus(status: 'online').then((_) {
          currentStatus.value = 'online';
          Get.snackbar("Online Mode", "You are now Online (Chats < 5).");
        });
      }
    }
  }

  void _handleConversationEnded(Map<String, dynamic> data) {
    final convId = data['conversationId']?.toString();
    if (convId == null) return;

    final index = conversations.indexWhere(
      (c) =>
          (c['conversationId']?.toString() == convId) ||
          (c['_id']?.toString() == convId),
    );

    if (index != -1) {
      final updatedConv = Map<String, dynamic>.from(conversations[index]);
      updatedConv['status'] = 'ended';
      updatedConv['isAccepted'] = false; // Usually ended means no longer active
      conversations[index] = updatedConv;
      _checkConcurrency(); // ✅ Check limit
    }
  }

  void _handleNewMessage(Map<String, dynamic> data) {
    final convId = data['conversationId']?.toString();
    if (convId == null) return;

    final index = conversations.indexWhere(
      (c) =>
          (c['conversationId']?.toString() == convId) ||
          (c['_id']?.toString() == convId),
    );

    if (index != -1) {
      final updatedConv = Map<String, dynamic>.from(conversations[index]);

      updatedConv['lastMessage'] = data;
      updatedConv['updatedAt'] =
          data['createdAt'] ?? DateTime.now().toIso8601String();

      if (data['senderRole'] == 'user' || data['senderType'] == 'user') {
        updatedConv['unreadCount'] = (updatedConv['unreadCount'] ?? 0) + 1;
      }

      conversations.removeAt(index);
      conversations.insert(0, updatedConv);
      _checkConcurrency(); // ✅ Check limit

      // ✅ Refresh global stats to update badge
      if (Get.isRegistered<GetUnreadCountController>()) {
        Get.find<GetUnreadCountController>().fetchStats();
      }
    } else {
      fetchConversations();
    }
  }

  void _handleReadReceipt(Map<String, dynamic> data) {
    final convId = data['conversationId']?.toString();
    if (convId == null) return;

    final index = conversations.indexWhere(
      (c) =>
          (c['conversationId']?.toString() == convId) ||
          (c['_id']?.toString() == convId),
    );

    if (index != -1) {
      final updatedConv = Map<String, dynamic>.from(conversations[index]);
      updatedConv['unreadCount'] = 0;
      conversations[index] = updatedConv;

      // ✅ Refresh global stats to update badge
      if (Get.isRegistered<GetUnreadCountController>()) {
        Get.find<GetUnreadCountController>().fetchStats();
      }
    }
  }

  List<Map<String, dynamic>> _extractList(dynamic response) {
    if (response is Map<String, dynamic>) {
      final data = response['data'];

      // ✅ Your API: { success:true, data:[...] }
      if (data is List) {
        return data
            .whereType<Map>()
            .map((e) => e.cast<String, dynamic>())
            .toList();
      }

      // ✅ Some APIs: { data: { conversations: [] } }
      if (data is Map && data['conversations'] is List) {
        return (data['conversations'] as List)
            .whereType<Map>()
            .map((e) => e.cast<String, dynamic>())
            .toList();
      }

      // ✅ Some APIs: { conversations: [] }
      if (response['conversations'] is List) {
        return (response['conversations'] as List)
            .whereType<Map>()
            .map((e) => e.cast<String, dynamic>())
            .toList();
      }
    }

    if (response is List) {
      return response
          .whereType<Map>()
          .map((e) => e.cast<String, dynamic>())
          .toList();
    }

    return <Map<String, dynamic>>[];
  }

  Future<bool?> fetchConversations({String? status}) async {
    isLoading.value = true;
    _currentFilterStatus.value = status ?? ''; // Update current filter
    try {
      final res = await repository.getConversations(status: status);
      final list = _extractList(res);
      conversations.assignAll(list);
      _checkConcurrency(); // ✅ Check limit
      return true;
    } on NoInternetException catch (e) {
      Get.snackbar("No Connection", e.toString());
      return false;
    } on ApiException catch (e) {
      Get.snackbar("Error !", e.message);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _socket.off(SocketEvents.newMessage);
    _socket.off(SocketEvents.newConversationRequest);
    _socket.off(SocketEvents.readReceipt);
    _socket.off(SocketEvents.partnerStatusChanged);
    super.onClose();
  }
}
