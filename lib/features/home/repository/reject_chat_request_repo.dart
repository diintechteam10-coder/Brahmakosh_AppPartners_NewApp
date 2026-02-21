import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../core/network/api_service.dart';
import '../models/response/conversation_reject_response.dart';

class RejectConversationRepository extends ApiService {
  Future<ConversationRejectResponse> rejectConversation({
    required String requestId,
    required String reason,
  }) async {
    try {
      final Response response = await apiClient.dio.post(
        "/api/chat/partner/requests/$requestId/reject",
        data: {"reason": reason},
      );

      final data = response.data;
      debugPrint("✅ rejectConversation SUCCESS: $data");

      if (data is Map<String, dynamic>) {
        return ConversationRejectResponse.fromJson(data);
      }

      return ConversationRejectResponse(
        success: false,
        message: "Invalid response",
      );
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final body = e.response?.data;

      print("❌ rejectConversation ERROR");
      print("TYPE: ${e.type}");
      print("MESSAGE: ${e.message}");
      print("ERROR: ${e.error}");
      print("STATUS: $status");
      print("BODY: $body");

      throw Exception(
        body is Map && body["message"] != null
            ? body["message"].toString()
            : "Reject failed ($status)",
      );
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}
