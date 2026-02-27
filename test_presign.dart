import 'package:dio/dio.dart';

void main() async {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://prod.brahmakosh.com',
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2OThhZDY4M2ZlNjZiY2UyYjM3NTczM2IiLCJyb2xlIjoicGFydG5lciIsImlhdCI6MTc3MjE5ODU2OCwiZXhwIjoxNzcyODAzMzY4fQ.PqVHVDFRtxHoLBYp_pDxXVAsQQkxv1iHWRiq879Zy94',
      },
    ),
  );

  final testKey =
      'voice-calls/698ad683fe66bce2b375733b_698c238e816366cfcd7c2f88_1772199210224/1772199413154_och6ejft65c.mp3';

  try {
    final response = await dio.post(
      '/api/upload/presigned-url',
      data: {
        'key': testKey,
        'fileName': 'audio.mp3',
        'contentType': 'audio/mpeg',
      },
    );
    print('Response: ${response.data}');
  } catch (e) {
    if (e is DioException) {
      print('Error ${e.response?.statusCode}: ${e.response?.data}');
    } else {
      print('Error: $e');
    }
  }
}
