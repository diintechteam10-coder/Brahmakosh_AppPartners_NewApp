import 'package:dio/dio.dart';
import '../../../core/network/api_service.dart';

class AstrologyRepository extends ApiService {
  /// GET /api/chat/conversation/:conversationId/astrology
  Future<dynamic> getUserAstrology({required String conversationId}) async {
    try {
      final Response response = await apiClient.dio.get(
        "/api/chat/conversation/$conversationId/astrology",
      );
      return response.data;
    } on DioException catch (e) {
      throw (e.error as Exception?) ?? Exception(e.message ?? 'Unknown error');
    }
  }

  /// GET /api/chat/conversation/:conversationId/complete-user-details
  Future<dynamic> getCompleteUserDetails({
    required String conversationId,
  }) async {
    try {
      final Response response = await apiClient.dio.get(
        "/api/chat/conversation/$conversationId/complete-user-details",
      );
      return response.data;
    } on DioException catch (e) {
      throw (e.error as Exception?) ?? Exception(e.message ?? 'Unknown error');
    }
  }
}
