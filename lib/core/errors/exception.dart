class ApiException implements Exception {
  final String message;
  ApiException({required this.message});

  @override
  String toString() => message;
}

class NoInternetException implements Exception {
  final String message;
  NoInternetException([this.message = "No Internet Connection"]);

  @override
  String toString() => message;
}

class UnauthorizedUser implements Exception {}
