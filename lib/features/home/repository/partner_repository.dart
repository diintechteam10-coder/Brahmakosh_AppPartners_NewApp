import 'package:dio/dio.dart';
import '../../../core/network/api_service.dart';

class PartnerRepository extends ApiService {
  /// GET /api/chat/partner/status
  Future<dynamic> getPartnerStatus() async {
    try {
      final Response response = await apiClient.dio.get(
        "/api/chat/partner/status",
      );
      return response.data;
    } on DioException catch (e) {
      print("❌ getPartnerStatus ERROR");
      print("STATUS: ${e.response?.statusCode}");
      print("BODY: ${e.response?.data}");
      throw (e.error as Exception?) ?? Exception(e.message ?? 'Unknown error');
    }
  }

  /// GET /api/credits/balance/partner
  Future<dynamic> getPartnerCredits() async {
    try {
      final Response response = await apiClient.dio.get(
        "/api/credits/balance/partner",
      );
      return response.data;
    } on DioException catch (e) {
      print("❌ getPartnerCredits ERROR");
      print("STATUS: ${e.response?.statusCode}");
      print("BODY: ${e.response?.data}");
      throw (e.error as Exception?) ?? Exception(e.message ?? 'Unknown error');
    }
  }
}
