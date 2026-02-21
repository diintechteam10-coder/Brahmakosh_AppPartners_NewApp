import 'package:brahmakoshpartners/core/network/api_service.dart';
import 'package:dio/dio.dart';

class HomeRepository extends ApiService {
  /// Partner availability status
  /// PDF: PATCH /partner/status { status: "online"|"offline"|"busy" }
  Future<dynamic> updatePartnerStatus({required String status}) async {
    try {
      final Response response = await apiClient.dio.patch(
        "/api/chat/partner/status",
        data: {"status": status},
      );
      return response.data;
    } on DioException catch (e) {
      throw e.error as Exception;
    }
  }
}
