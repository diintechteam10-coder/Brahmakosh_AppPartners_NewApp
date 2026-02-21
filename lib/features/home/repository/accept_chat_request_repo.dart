import 'package:dio/dio.dart';
import '../../../core/network/api_service.dart';
import '../models/response/conversation_accepted_response.dart'; // ✅ jo response class banayi hai
// or: import '../models/accept_conversation_response.dart';

class AcceptConversationRepository extends ApiService {
  Future<ConversationAcceptedResponse> acceptConversation({
    required String requestId,
  }) async {
    try {
      final Response response = await apiClient.dio.post(
        "/api/chat/partner/requests/$requestId/accept",
        // data: {}, // if backend expects body, uncomment
      );

      final data = response.data;

      if (data is Map<String, dynamic>) {
        return ConversationAcceptedResponse.fromJson(data);
      }

      return ConversationAcceptedResponse(
        success: false,
        message: "Invalid response",
        data: null,
      );
    }

    /// ✅ REAL ERROR PRINT
    on DioException catch (e) {
      final status = e.response?.statusCode;
      final body = e.response?.data;

      print("❌ acceptConversation ERROR");
      print("TYPE: ${e.type}");
      print("MESSAGE: ${e.message}");
      print("ERROR: ${e.error}");
      print("STATUS: $status");
      print("BODY: $body");

      throw Exception(
        body is Map && body["message"] != null
            ? body["message"].toString()
            : "Accept failed ($status)",
      );
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}
