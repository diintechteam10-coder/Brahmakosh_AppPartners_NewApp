import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../models/responses/mark_as_read_response.dart';
import '../repository/mark_as_read_repository.dart';

class MarkAsReadController extends GetxController {
  final MarkAsReadRepository repository = MarkAsReadRepository();

  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  final Rxn<MarkAsReadResponse> lastResponse = Rxn<MarkAsReadResponse>();

  Future<void> markAsRead({required String conversationId}) async {
    try {
      isLoading.value = true;
      error.value = '';

      final res = await repository.markConversationAsRead(
        conversationId: conversationId,
      );

      lastResponse.value = res;

      if (res.success != true) {
        error.value = res.message ?? "Failed to mark as read";
      }
    } catch (e) {
      debugPrint("❌ MarkAsReadController Error: $e");
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
