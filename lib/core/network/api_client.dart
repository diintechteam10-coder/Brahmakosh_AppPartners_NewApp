import 'package:brahmakoshpartners/core/services/tokens.dart';
import 'package:brahmakoshpartners/core/const/app_urls.dart';
import 'package:dio/dio.dart';
import '../globals/logger.dart';
import 'dio_error_mapper.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiClient {
  late final Dio dio;

  ApiClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: AppUrls.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.addAll([
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await Tokens.token;

          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (error, handler) {
          final exception = DioErrorMapper.map(error);
          handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              error: exception,
            ),
          );
        },
      ),

      InterceptorsWrapper(
        onRequest: (options, handler) {
          logger.d("${options.method} -> ${options.path}");
          if (options.data != null) {
            logger.d(options.data);
          }
          return handler.next(options);
        },

        onResponse: (response, handler) {
          // logger.d(response.data);
          return handler.next(response);
        },

        onError: (error, handler) {
          logger.e("API ERROR IN -> ${error.requestOptions.path}");
          logger.e(error.response?.data);
          return handler.next(error);
        },
      ),
      PrettyDioLogger(
        requestHeader: true,
        requestBody: false,
        responseBody: false,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    ]);
  }
}
