import 'package:dio/dio.dart';
import '../../../core/network/api_service.dart';
import '../models/get_unread_count_response.dart';

class GetUnreadCountRepository extends ApiService {
  Future<GetUnreadCountResponse> getConversationStats() async {
    try {
      final Response response = await apiClient.dio.get(
        "/api/chat/conversations/stats",
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        return GetUnreadCountResponse.fromJson(data);
      }

      return GetUnreadCountResponse(success: false, data: null);
    } on DioException catch (e) {
      throw (e.error as Exception?) ??
          Exception(e.message ?? 'Failed to load conversation stats');
    }
  }
}
