// import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart';
// import 'package:get/get.dart';

// import '../models/new_conversation_request.dart';
// import '../repository/new_chat_repository.dart';

// class ConversationRequestController extends GetxController {
//   final ConversationRequestRepository repository =
//       ConversationRequestRepository();

//   /// UI State
//   final RxBool isLoading = false.obs;
//   final RxString error = ''.obs;

//   /// Data
//   final RxList<ConversationRequest> requests = <ConversationRequest>[].obs;
//   final RxInt totalRequests = 0.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     fetchRequests(); // auto load
//   }

//   void clear() {
//     requests.clear();
//     totalRequests.value = 0;
//     error.value = '';
//     isLoading.value = false;
//   }

//   Future<void> fetchRequests() async {
//     try {
//       isLoading.value = true;
//       error.value = '';

//       final ConversationRequestResponse res = await repository
//           .getConversationRequests();

//       if (res.success == true && res.data != null) {
//         debugPrint(
//           "📥 Fetched Chat Requests: ${res.data!.requests.length} requests found",
//         );
//         requests.assignAll(res.data!.requests);
//         totalRequests.value = res.data!.totalRequests;
//       } else {
//         requests.clear();
//         totalRequests.value = 0;
//         error.value = 'No requests found';
//       }
//     } catch (e) {
//       debugPrint("❌ ConversationRequestController Error: $e");
//       error.value = e.toString();
//       Get.snackbar(
//         "Request Error",
//         e.toString(),
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red.withOpacity(0.7),
//         colorText: Colors.white,
//       );
//       requests.clear();
//       totalRequests.value = 0;
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   /// Pull-to-refresh helper
//   Future<void> refreshRequests() async {
//     await fetchRequests();
//   }

//   /// Optional helpers
//   ConversationRequest? requestByConversationId(String conversationId) {
//     try {
//       return requests.firstWhere((r) => r.conversationId == conversationId);
//     } catch (_) {
//       return null;
//     }
//   }

//   int get pendingCount =>
//       requests.where((r) => (r.status ?? '') == 'pending').length;

//   int get acceptedCount =>
//       requests.where((r) => (r.status ?? '') == 'accepted').length;

//   int get rejectedCount =>
//       requests.where((r) => (r.status ?? '') == 'rejected').length;
// }




import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/response/new_chat_request_response.dart';
import '../repository/new_chat_repository.dart';

class ConversationRequestController extends GetxController {
  final ConversationRequestRepository repository =
      ConversationRequestRepository();

  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  final RxList<ConversationRequest> requests = <ConversationRequest>[].obs;
  final RxInt totalRequests = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRequests();
  }

  void clear() {
    requests.clear();
    totalRequests.value = 0;
    error.value = '';
    isLoading.value = false;
  }

  Future<void> fetchRequests() async {
    try {
      isLoading.value = true;
      error.value = '';

      final res = await repository.getConversationRequests();

      if (res.success == true && res.data != null) {
        requests.assignAll(res.data!.requests);
        totalRequests.value = res.data!.totalRequests;

        debugPrint("📥 Chat Requests Loaded: ${requests.length}");
      } else {
        requests.clear();
        totalRequests.value = 0;
        error.value = 'No requests found';
      }
    } catch (e) {
      debugPrint("❌ Controller Error: $e");

      error.value = e.toString();

      Get.snackbar(
        "Request Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );

      requests.clear();
      totalRequests.value = 0;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshRequests() async {
    await fetchRequests();
  }
}



