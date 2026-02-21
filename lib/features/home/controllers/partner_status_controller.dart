import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../models/response/partner_status_response.dart';
import '../repository/partner_status_repo.dart';

class PartnerStatusController extends GetxController {
  final PartnerStatusRepository repository = PartnerStatusRepository();

  /// UI State
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  /// Data
  final Rxn<PartnerStatusData> partner = Rxn<PartnerStatusData>();
  final RxString currentStatus = 'offline'.obs;

  /// Optional: full response
  final Rxn<UpdatePartnerStatusResponse> lastResponse =
      Rxn<UpdatePartnerStatusResponse>();

  Future<void> updateStatus(String status) async {
    try {
      isLoading.value = true;
      error.value = '';

      final UpdatePartnerStatusResponse res =
          await repository.updatePartnerStatus(status: status);

      lastResponse.value = res;

      if (res.success == true && res.data != null) {
        partner.value = res.data;
        currentStatus.value = res.data!.onlineStatus; // "online"/"offline"
      } else {
        error.value = res.message.isNotEmpty ? res.message : "Update failed";
      }
    } catch (e) {
      debugPrint("❌ PartnerStatusController Error: $e");
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void clear() {
    error.value = '';
    partner.value = null;
    lastResponse.value = null;
    currentStatus.value = 'offline';
  }
}
