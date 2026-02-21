import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../models/response/conversation_reject_response.dart';
import '../repository/reject_chat_request_repo.dart';


class RejectConversationController extends GetxController {
  final RejectConversationRepository repository = RejectConversationRepository();

  /// UI state
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  /// last response (optional)
  final Rxn<ConversationRejectResponse> lastResponse = Rxn<ConversationRejectResponse>();

  Future<void> reject({
    required String requestId,
    required String reason,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';
      lastResponse.value = null;

      final res = await repository.rejectConversation(
        requestId: requestId,
        reason: reason,
      );

      lastResponse.value = res;

      if (res.success != true) {
        error.value = res.message.isNotEmpty ? res.message : "Reject failed";
      }
    } catch (e) {
      debugPrint("❌ RejectConversationController Error: $e");
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void clear() {
    error.value = '';
    lastResponse.value = null;
  }
}
