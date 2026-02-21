import 'package:dio/dio.dart';
import '../../../core/network/api_service.dart';

class ConversationRepository extends ApiService {
  Future<dynamic> getConversations({String? status}) async {
    try {
      final String url = (status == null || status.trim().isEmpty)
          ? "/api/chat/conversations"
          : "/api/chat/conversations?status=${Uri.encodeComponent(status)}";

      final Response response = await apiClient.dio.get(url);
      return response.data;
    } on DioException catch (e) {
      throw (e.error as Exception?) ?? Exception(e.message ?? 'Unknown error');
    }
  }

  /// PATCH /api/chat/conversations/:conversationId/accept
  Future<dynamic> acceptConversation({required String conversationId}) async {
    try {
      final Response response = await apiClient.dio.patch(
        "/api/chat/conversations/$conversationId/accept",
      );
      return response.data;
    } on DioException catch (e) {
      throw (e.error as Exception?) ?? Exception(e.message ?? 'Unknown error');
    }
  }

  /// PATCH /api/chat/conversations/:conversationId/reject { reason }
  Future<dynamic> rejectConversation({
    required String conversationId,
    required String reason,
  }) async {
    try {
      final Response response = await apiClient.dio.patch(
        "/api/chat/conversations/$conversationId/reject",
        data: {"reason": reason},
      );
      return response.data;
    } on DioException catch (e) {
      throw (e.error as Exception?) ?? Exception(e.message ?? 'Unknown error');
    }
  }

  /// PATCH /api/chat/conversations/:conversationId/end
  Future<dynamic> endConversation({required String conversationId}) async {
    try {
      final Response response = await apiClient.dio.patch(
        "/api/chat/conversations/$conversationId/end",
      );
      return response.data;
    } on DioException catch (e) {
      throw (e.error as Exception?) ?? Exception(e.message ?? 'Unknown error');
    }
  }
}
