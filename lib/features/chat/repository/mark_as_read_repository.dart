import 'package:dio/dio.dart';
import '../../../core/network/api_service.dart';
import '../models/responses/mark_as_read_response.dart';

class MarkAsReadRepository extends ApiService {
  Future<MarkAsReadResponse> markConversationAsRead({
    required String conversationId,
  }) async {
    try {
      final Response response = await apiClient.dio.patch(
        "/api/chat/conversations/$conversationId/read",
        data: {}, // ✅ Added empty body to avoid 400 Bad Request
      );

      final data = response.data;

      if (data is Map<String, dynamic>) {
        return MarkAsReadResponse.fromJson(data);
      }

      return MarkAsReadResponse(
        success: false,
        message: "Invalid response format",
      );
    }
    /// ✅ REAL ERROR PRINT (same style as your project)
    on DioException catch (e) {
      final status = e.response?.statusCode;
      final body = e.response?.data;

      print("❌ markConversationAsRead ERROR");
      print("TYPE: ${e.type}");
      print("MESSAGE: ${e.message}");
      print("ERROR: ${e.error}");
      print("STATUS: $status");
      print("BODY: $body");

      throw Exception(
        body is Map && body["message"] != null
            ? body["message"].toString()
            : "Mark as read failed ($status)",
      );
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}
