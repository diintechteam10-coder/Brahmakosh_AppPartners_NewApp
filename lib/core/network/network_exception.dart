enum NetworkErrorType {
  requestCancelled,
  unauthorised,
  forbidden,
  notFound,
  conflict,
  requestTimeout,
  sendTimeout,
  receiveTimeout,
  serverError,
  serviceUnavailable,
  noInternet,
  formatException,
  unexpected,
}

class NetworkException implements Exception {
  final NetworkErrorType type;
  final String message;
  final int? statusCode;

  NetworkException({
    required this.type,
    required this.message,
    this.statusCode,
  });

  @override
  String toString() => message;
}