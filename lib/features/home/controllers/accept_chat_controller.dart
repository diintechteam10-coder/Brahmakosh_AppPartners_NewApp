import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../repository/accept_chat_request_repo.dart';
import '../models/response/conversation_accepted_response.dart';

class AcceptConversationController extends GetxController {
  final AcceptConversationRepository repository = AcceptConversationRepository();

  /// UI State
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  /// Data
  final Rxn<ConversationData> acceptedConversation = Rxn<ConversationData>();

  /// Optional: last full response (debug / future use)
  final Rxn<ConversationAcceptedResponse> lastResponse =
      Rxn<ConversationAcceptedResponse>();

  Future<void> accept({
    required String requestId,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';
      acceptedConversation.value = null;

      final ConversationAcceptedResponse res =
          await repository.acceptConversation(requestId: requestId);

      lastResponse.value = res;

      if (res.success == true && res.data != null) {
        acceptedConversation.value = res.data;
      } else {
        error.value = res.message.isNotEmpty ? res.message : "Accept failed";
      }
    } catch (e) {
      debugPrint("❌ AcceptConversationController Error: $e");
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void clear() {
    error.value = '';
    acceptedConversation.value = null;
    lastResponse.value = null;
  }
}
