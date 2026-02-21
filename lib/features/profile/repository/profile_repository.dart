import 'package:brahmakoshpartners/core/network/api_service.dart';
import 'package:dio/dio.dart';

import '../models/profile_model.dart';

class PartnerProfileRepository extends ApiService {
  /// ✅ GET PARTNER PROFILE
  /// GET /api/partner/profile
  Future<PartnerProfileResponse> getProfile() async {
    try {
      final Response response = await apiClient.dio.get(
        "/api/mobile/partner/profile",
      );

      final data = response.data;

      if (data is Map<String, dynamic>) {
        return PartnerProfileResponse.fromJson(data);
      }

      return PartnerProfileResponse(
        success: false,
        message: "Invalid response",
        data: PartnerProfileData(
          partner: Partner(
            id: '',
            name: '',
            email: '',
            phone: '',
            bio: null,
            profilePictureUrl: '',
            specialization: const [],
            languages: const [],
            experience: 0,
            chatCharge: 0,
            voiceCharge: 0,
            videoCharge: 0,
            currency: 'INR',
            isActive: false,
            isVerified: false,
            onlineStatus: 'offline',
          ),
          token: '',
        ),
      );
    } on DioException catch (e) {
      throw (e.error as Exception?) ??
          Exception(e.message ?? 'Failed to load profile');
    }
  }
}
