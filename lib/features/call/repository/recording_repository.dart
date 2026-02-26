import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/network/api_service.dart';

class RecordingRepository extends ApiService {
  /// Step 1: Get Upload URL
  Future<String?> getUploadUrl({required String conversationId}) async {
    try {
      final response = await apiClient.dio.post(
        "/api/chat/voice/recording/upload-url",
        data: {"conversationId": conversationId, "role": "partner"},
      );

      final data = response.data;
      if (data is Map<String, dynamic> && data['success'] == true) {
        return data['data']?['uploadUrl']?.toString();
      }
      return null;
    } catch (e) {
      debugPrint("❌ getUploadUrl ERROR: $e");
      return null;
    }
  }

  /// Step 2: Upload file via PUT to S3 directly (NO AUTH)
  Future<bool> uploadRecordingFile({
    required String uploadUrl,
    required List<int> fileBytes,
  }) async {
    try {
      final dioNoAuth =
          Dio(); // Basic Dio without interceptors for direct S3 upload

      final response = await dioNoAuth.put(
        uploadUrl,
        data: Stream.fromIterable([fileBytes]),
        options: Options(
          headers: {
            "Content-Type": "audio/webm",
            "Content-Length": fileBytes.length.toString(),
          },
        ),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      debugPrint("❌ uploadRecordingFile ERROR: $e");
      return false;
    }
  }

  /// Step 3: Attach Recording to Conversation
  Future<bool> attachRecordingToConversation({
    required String conversationId,
  }) async {
    try {
      final response = await apiClient.dio.patch(
        "/api/chat/conversations/$conversationId/voice-recording",
      );

      final data = response.data;
      if (data is Map<String, dynamic> && data['success'] == true) {
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("❌ attachRecordingToConversation ERROR: $e");
      return false;
    }
  }
}
