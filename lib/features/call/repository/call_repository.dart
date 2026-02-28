import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../core/network/api_client.dart';
import '../models/call_history_response.dart';

class CallRepository {
  final ApiClient apiClient = ApiClient();

  Future<CallHistoryResponse?> fetchCallHistory({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await apiClient.dio.get(
        '/api/chat/voice/calls/history/partner',
        queryParameters: {'page': page, 'limit': limit},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return CallHistoryResponse.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message ?? '$e');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<String?> fetchSignedUrl(String key) async {
    try {
      final fileName = key.split('/').last;

      final response = await apiClient.dio.post(
        '/api/upload/presigned-url',
        data: {"key": key, "fileName": fileName, "contentType": "audio/mpeg"},
      );

      debugPrint("SIGNED URL RESPONSE: ${response.data}");

      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data['data']['presignedUrl'];
      }

      return null;
    } on DioException catch (e) {
      debugPrint("DIO ERROR: ${e.response?.data}");
      rethrow;
    } catch (e) {
      debugPrint("UNKNOWN ERROR: $e");
      rethrow;
    }
  }
}
