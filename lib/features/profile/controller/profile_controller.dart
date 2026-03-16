// import 'package:get/get.dart';

// import '../models/profile_model.dart';
// import '../repository/profile_repository.dart';
// import '../../home/repository/partner_repository.dart';

// class PartnerProfileController extends GetxController {
//   final PartnerProfileRepository repository = PartnerProfileRepository();
//   final PartnerRepository partnerRepository = PartnerRepository();

//   final RxBool isLoading = false.obs;
//   final RxString error = ''.obs;

//   /// full response (optional)
//   final Rxn<PartnerProfileResponse> response = Rxn<PartnerProfileResponse>();

//   /// directly useful partner object for UI
//   final Rxn<Partner> partner = Rxn<Partner>();

//   /// token returned by API (if you want to update stored token)
//   final RxString token = ''.obs;

//   /// New features
//   final RxDouble credits = 0.0.obs;
//   final RxString status = 'offline'.obs;
//   final RxDouble totalEarnings = 0.0.obs;
//   final RxInt totalClients = 0.obs;

//   /// Call this when screen loads
//   Future<void> fetchProfile() async {
//     isLoading.value = true;
//     error.value = '';

//     try {
//       final res = await repository.getProfile();
//       response.value = res;

//       if (res.success == true) {
//         partner.value = res.data.partner;
//         token.value = res.data.token;
//       } else {
//         error.value = res.message;
//       }

//       // Also fetch partner details (credits/status)
//       await fetchPartnerDetails();
//     } catch (e) {
//       error.value = e.toString();
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> fetchPartnerDetails() async {
//     try {
//       final creditRes = await partnerRepository.getPartnerCredits();
//       if (creditRes is Map && creditRes['data'] != null) {
//         credits.value =
//             (creditRes['data']['credits'] as num?)?.toDouble() ?? 0.0;
//         totalEarnings.value =
//             (creditRes['data']['totalEarnings'] as num?)?.toDouble() ?? 0.0;
//         totalClients.value = (creditRes['data']['totalClients'] as int?) ?? 0;
//       }

//       final statusRes = await partnerRepository.getPartnerStatus();
//       if (statusRes is Map && statusRes['data'] != null) {
//         status.value = statusRes['data']['status']?.toString() ?? 'offline';
//       }
//     } catch (e) {
//       print("Error fetching partner details: $e");
//     }
//   }

//   @override
//   void onInit() {
//     super.onInit();
//     fetchProfile();
//   }
// }




import 'package:get/get.dart';
import '../models/profile_model.dart';
import '../repository/profile_repository.dart';
import '../../home/repository/partner_repository.dart';

class PartnerProfileController extends GetxController {
  final PartnerProfileRepository repository = PartnerProfileRepository();
  final PartnerRepository partnerRepository = PartnerRepository();

  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  final Rxn<PartnerProfileResponse> response =
      Rxn<PartnerProfileResponse>();

  final Rxn<Partner> partner = Rxn<Partner>();
  final RxString token = ''.obs;

  final RxDouble credits = 0.0.obs;
  final RxString status = 'offline'.obs;
  final RxDouble totalEarnings = 0.0.obs;
  final RxInt totalClients = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    isLoading.value = true;
    error.value = '';

    try {
      final res = await repository.getProfile();
      response.value = res;

      if (res.success) {
        partner.value = res.data.partner;
        token.value = res.data.token;

        // Stats from profile API
        totalEarnings.value =
            res.data.partner.stats.totalEarnings.toDouble();
      } else {
        error.value = res.message;
      }

      await fetchPartnerDetails();
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchPartnerDetails() async {
    try {
      // Use balance from the profile model if available
      if (partner.value != null) {
        credits.value = partner.value!.creditsEarnedBalance;
      }

      // getPartnerStatus is still valid
      final statusRes = await partnerRepository.getPartnerStatus();

      if (statusRes is Map && statusRes['data'] != null) {
        status.value =
            statusRes['data']['status']?.toString() ?? 'offline';
      }
    } catch (e) {
      print("Error fetching partner details: $e");
    }
  }
}