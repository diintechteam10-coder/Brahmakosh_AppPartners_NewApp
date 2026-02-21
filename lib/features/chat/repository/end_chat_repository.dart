// import 'package:brahmakoshpartners/core/network/api_service.dart';
// import 'package:dio/dio.dart';

// import '../models/responses/chat_end_response_model.dart';

// class EndChatRepository extends ApiService {
//   /// ✅ END CHAT (REST)
//   /// PATCH /api/chat/conversations/:conversationId/end
//   Future<ConversationEndResponse> endChat({
//     required String conversationId,
//   }) async {
//     try {
//       final Response response = await apiClient.dio.patch(
//         "/api/chat/conversations/$conversationId/end",
//       );

//       final data = response.data;
//       if (data is Map<String, dynamic>) {
//         return ConversationEndResponse.fromJson(data);
//       }

//       return ConversationEndResponse(success: false, data: null);
//     } on DioException catch (e) {
//       throw (e.error as Exception?) ?? Exception(e.message ?? 'Unknown error');
//     }
//   }
// }

import 'package:brahmakoshpartners/core/network/api_service.dart';
import 'package:dio/dio.dart';

import '../models/request/end_chat_request.dart';
import '../models/responses/chat_end_response_model.dart';

class EndChatRepository extends ApiService {
  Future<ConversationEndResponse> endChat({
    required String conversationId,
    required EndChatRequest request,
  }) async {
    try {
      final Response response = await apiClient.dio.patch(
        "/api/chat/conversations/$conversationId/end",
        data: request.toJson(),
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        return ConversationEndResponse.fromJson(data);
      }
      return ConversationEndResponse(success: false, data: null);
    } on DioException catch (e) {
      final msg = e.response?.data is Map
          ? (e.response?.data['message']?.toString() ?? e.message)
          : e.message;
      throw Exception(msg ?? 'Unknown error');
    }
  }
}

// class EndChatRepository extends ApiService {
//   Future<ConversationEndResponse> endChat({
//     required String conversationId,
//     required EndChatRequest request, // ✅ added
//   }) async {
//     try {
//       final Response response = await apiClient.dio.patch(
//         "/api/chat/conversations/$conversationId/end",
//         data: request.toJson(), // ✅ send body
//       );

//       final data = response.data;
//       if (data is Map<String, dynamic>) {
//         return ConversationEndResponse.fromJson(data);
//       }

//       return ConversationEndResponse(success: false, data: null);
//     } on DioException catch (e) {
//       final msg = e.response?.data is Map
//           ? (e.response?.data['message']?.toString() ?? e.message)
//           : e.message;
//       throw Exception(msg ?? 'Unknown error');
//     }
//   }
// }
