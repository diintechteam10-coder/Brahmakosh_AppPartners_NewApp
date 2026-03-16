import 'dart:io';
import 'package:brahmakoshpartners/core/errors/exception.dart';
import 'package:brahmakoshpartners/core/network/network_exception.dart';
import 'package:dio/dio.dart';

class DioErrorMapper {
  static Exception map(DioException error) {
    switch (error.type) {
      case DioExceptionType.cancel:
        return NetworkException(
          type: NetworkErrorType.requestCancelled,
          message: 'Request cancelled',
        );

      case DioExceptionType.connectionTimeout:
        return NetworkException(
          type: NetworkErrorType.requestTimeout,
          message: 'Connection timeout',
        );

      case DioExceptionType.sendTimeout:
        return NetworkException(
          type: NetworkErrorType.sendTimeout,
          message: 'Request send timeout',
        );

      case DioExceptionType.receiveTimeout:
        return NetworkException(
          type: NetworkErrorType.receiveTimeout,
          message: 'Response timeout',
        );

      case DioExceptionType.badResponse:
        final data = error.response?.data;
        final statusCode = error.response?.statusCode;
        final message = data is Map && data['message'] != null
            ? data['message'].toString()
            : 'Bad request';

        return ApiException(
          message: statusCode != null ? "($statusCode) $message" : message,
        );

      case DioExceptionType.connectionError:
        if (error.error is SocketException) {
          final socketException = error.error as SocketException;
          return NoInternetException(socketException.message);
        }
        return NetworkException(
          type: NetworkErrorType.unexpected,
          message: 'Connection error',
        );

      case DioExceptionType.unknown:
        return NetworkException(
          type: NetworkErrorType.unexpected,
          message: 'Unexpected error occurred',
        );
      case DioExceptionType.badCertificate:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }
}
