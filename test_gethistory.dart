import 'package:dio/dio.dart';

void main() async {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://prod.brahmakosh.com',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2OThhZDY4M2ZlNjZiY2UyYjM3NTczM2IiLCJyb2xlIjoicGFydG5lciIsImlhdCI6MTc3MjE5ODU2OCwiZXhwIjoxNzcyODAzMzY4fQ.PqVHVDFRtxHoLBYp_pDxXVAsQQkxv1iHWRiq879Zy94',
      },
    ),
  );

  try {
    final response = await dio.get('/api/chat/voice/calls/history/partner?page=1&limit=2');
    print('Response: ${response.data}');
  } catch (e) {
    if (e is DioException) {
      print('Error ${e.response?.statusCode}: ${e.response?.data}');
    } else {
      print('Error: $e');
    }
  }
}
