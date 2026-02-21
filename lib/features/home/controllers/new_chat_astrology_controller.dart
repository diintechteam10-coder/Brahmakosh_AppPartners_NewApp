import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../models/response/new_chat_astrology_response.dart';
import '../repository/new_chat_astrology_repo.dart';

class ConversationAstrologyController extends GetxController {
  final ConversationAstrologyRepository repository =
      ConversationAstrologyRepository();
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  final Rxn<NewIncomingRequestData> astrology = Rxn<NewIncomingRequestData>();
  final Rxn<NewChatAstrologyResponse> lastResponse =
      Rxn<NewChatAstrologyResponse>();

  Future<void> fetchAstrology({required String conversationId}) async {
    try {
      isLoading.value = true;
      error.value = '';
      astrology.value = null;

      final res = await repository.getConversationAstrology(
        conversationId: conversationId,
      );

      lastResponse.value = res;

      if (res.success == true && res.data != null) {
        astrology.value = res.data;
      } else {
        error.value = "No astrology data found";
      }
    } catch (e) {
      debugPrint("❌ ConversationAstrologyController Error: $e");
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void clear() {
    error.value = '';
    astrology.value = null;
    lastResponse.value = null;
  }
}
