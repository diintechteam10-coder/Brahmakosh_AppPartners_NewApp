import 'package:brahmakoshpartners/core/network/api_service.dart';
import 'package:brahmakoshpartners/core/services/current_user.dart';
import 'package:brahmakoshpartners/core/services/tokens.dart';
import 'package:dio/dio.dart';

class AuthRepository extends ApiService {
  Future<void> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final payload = {
        "email": email,
        "password": password,
        "clientId": "CLI-KBHUMT",
      };

      final Response response = await apiClient.dio.post(
        "/api/mobile/partner/login",
        data: payload,
      );

      final data = response.data?['data'];
      if (data == null || data is! Map) {
        throw Exception("Invalid response: data missing");
      }

      final token = data['token']?.toString();
      final partner = data['partner'];

      if (token == null || token.isEmpty) {
        throw Exception("Login token missing");
      }

      if (partner == null || partner is! Map) {
        throw Exception("Partner object missing");
      }

      await CurrentUser().save({
        "email": partner["email"],
        "user": partner,
        "partner": partner,
        "role": "partner",
        "registrationStep": partner["registrationStep"],
      });

      await Tokens.save(token);

    } on DioException catch (e) {
      final msg = e.response?.data?["message"]?.toString();
      throw Exception(msg ?? "Login failed");
    }
  }
}
