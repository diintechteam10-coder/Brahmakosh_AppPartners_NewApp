import 'package:brahmakoshpartners/core/network/api_service.dart';
import 'package:dio/dio.dart';

import '../models/responses/users_message_response_model.dart';

class ChatRepository extends ApiService {
  /// GET /api/chat/conversations/:conversationId/messages?page=...&limit=...
  Future<ChatMessagesResponse> getMessages({
    required String conversationId,
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final Response response = await apiClient.dio.get(
        "/api/chat/conversations/$conversationId/messages",
        queryParameters: {
          "page": page,
          "limit": limit,
        },
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        return ChatMessagesResponse.fromJson(data);
      }
      // fallback (if backend returns non-map)
      return ChatMessagesResponse(success: false, data: null);
    } on DioException catch (e) {
      throw (e.error as Exception?) ?? Exception(e.message ?? 'Unknown error');
    }
  }
}
