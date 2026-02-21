import 'package:brahmakoshpartners/core/network/api_service.dart';
import 'package:dio/dio.dart';
import '../models/request/send_message_request_model.dart';
import '../models/responses/send_msg_response_model.dart';

class SendMessageRepository extends ApiService {
  /// ✅ SEND MESSAGE (REST)
  /// POST /api/chat/conversations/:conversationId/messages
  Future<SendMessageResponse> sendMessage({
    required String conversationId,
    required SendMessageRequest request,
  }) async {
    try {
      final Response response = await apiClient.dio.post(
        "/api/chat/conversations/$conversationId/messages",
        data: request.toJson(),
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        return SendMessageResponse.fromJson(data);
      }

      return SendMessageResponse(success: false, data: null);
    } on DioException catch (e) {
      throw (e.error as Exception?) ?? Exception(e.message ?? 'Unknown error');
    }
  }
}
