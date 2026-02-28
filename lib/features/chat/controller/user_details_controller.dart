import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:brahmakoshpartners/features/astrology/repository/astrology_repository.dart';
import 'package:brahmakoshpartners/features/chat/models/responses/complete_user_details_response.dart';

class UserDetailsController extends GetxController {
  final AstrologyRepository _repository = AstrologyRepository();

  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;
  final Rxn<CompleteUserData> userData = Rxn<CompleteUserData>();

  Future<void> fetchUserDetails(String conversationId) async {
    try {
      isLoading.value = true;
      error.value = '';
      userData.value = null;

      final dynamic response = await _repository.getCompleteUserDetails(
        conversationId: conversationId,
      );

      final CompleteUserDetailsResponse res =
          CompleteUserDetailsResponse.fromJson(response);

      if (res.success == true && res.data != null) {
        userData.value = res.data;
      } else {
        error.value = "Failed to load user details";
      }
    } catch (e) {
      debugPrint("❌ UserDetailsController Error: $e");
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
