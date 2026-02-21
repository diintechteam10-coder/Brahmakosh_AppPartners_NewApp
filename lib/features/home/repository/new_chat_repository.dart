

import 'package:dio/dio.dart';
import '../../../core/network/api_service.dart';
import '../models/response/new_chat_request_response.dart';

class ConversationRequestRepository extends ApiService {
  Future<ConversationRequestResponse> getConversationRequests() async {
    try {
      final Response response = await apiClient.dio.get(
        "/api/chat/partner/requests",
      );

      final data = response.data;

      if (data is Map<String, dynamic>) {
        return ConversationRequestResponse.fromJson(data);
      }

      return ConversationRequestResponse(success: false, data: null);
    }
    /// ✅ REAL ERROR PRINT
    on DioException catch (e) {
      final status = e.response?.statusCode;
      final body = e.response?.data;

      print("❌ getConversationRequests ERROR");
      print("TYPE: ${e.type}");
      print("MESSAGE: ${e.message}");
      print("ERROR: ${e.error}");
      print("STATUS: $status");
      print("BODY: $body");

      throw Exception(
        body is Map && body["message"] != null
            ? body["message"].toString()
            : "Request failed ($status)",
      );
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}
