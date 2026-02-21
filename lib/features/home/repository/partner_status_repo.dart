import 'package:dio/dio.dart';
import '../../../core/network/api_service.dart';
import '../models/request/partner_status_request.dart';
import '../models/response/partner_status_response.dart';


class PartnerStatusRepository extends ApiService {
  Future<UpdatePartnerStatusResponse> updatePartnerStatus({
    required String status, // "online" | "offline"
  }) async {
    try {
      final req = UpdatePartnerStatusRequest(status: status);

      final Response response = await apiClient.dio.patch(
        "/api/chat/partner/status",
        data: req.toJson(),
      );

      final data = response.data;

      if (data is Map<String, dynamic>) {
        return UpdatePartnerStatusResponse.fromJson(data);
      }

      return UpdatePartnerStatusResponse(
        success: false,
        message: "Invalid response",
        data: null,
      );
    }

    /// ✅ REAL ERROR PRINT
    on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final body = e.response?.data;

      print("❌ updatePartnerStatus ERROR");
      print("TYPE: ${e.type}");
      print("MESSAGE: ${e.message}");
      print("ERROR: ${e.error}");
      print("STATUS: $statusCode");
      print("BODY: $body");

      throw Exception(
        body is Map && body["message"] != null
            ? body["message"].toString()
            : "Status update failed ($statusCode)",
      );
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}
