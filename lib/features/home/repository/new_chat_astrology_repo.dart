import 'package:dio/dio.dart';
import '../../../core/network/api_service.dart';
import '../models/response/new_chat_astrology_response.dart';

class ConversationAstrologyRepository extends ApiService {
  Future<NewChatAstrologyResponse> getConversationAstrology({
    required String conversationId,
  }) async {
    try {
      final Response response = await apiClient.dio.get(
        "/api/chat/conversation/$conversationId/astrology",
      );

      final data = response.data;

      if (data is Map<String, dynamic>) {
        return NewChatAstrologyResponse.fromJson(data);
      }

      return NewChatAstrologyResponse(success: false, data: null);
    }

    /// ✅ REAL ERROR PRINT
    on DioException catch (e) {
      final status = e.response?.statusCode;
      final body = e.response?.data;

      print("❌ getConversationAstrology ERROR");
      print("TYPE: ${e.type}");
      print("MESSAGE: ${e.message}");
      print("ERROR: ${e.error}");
      print("STATUS: $status");
      print("BODY: $body");

      throw Exception(
        body is Map && body["message"] != null
            ? body["message"].toString()
            : "Astrology fetch failed ($status)",
      );
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}
