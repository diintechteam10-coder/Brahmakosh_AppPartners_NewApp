import 'package:brahmakoshpartners/core/services/tokens.dart';
import 'package:brahmakoshpartners/core/const/app_urls.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../globals/logger.dart';
import 'dio_error_mapper.dart';

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

          logger.d("${options.method} -> ${options.path}");
          if (options.data != null) {
            logger.d(options.data);
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (error, handler) {
          logger.e("API ERROR IN -> ${error.requestOptions.path}");
          if (error.response?.data != null) {
            logger.e("ERROR BODY: ${error.response?.data}");
          } else {
            logger.e("ERROR MESSAGE: ${error.message}");
          }

          // Map the error but preserve the original exception context if possible
          final exception = DioErrorMapper.map(error);
          
          // We reject with a new exception that contains our mapped ApiException in the 'error' field,
          // BUT we must also preserve the 'response' so repositories can inspect it.
          return handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              response: error.response,
              type: error.type,
              error: exception,
              message: exception.toString(),
            ),
          );
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
