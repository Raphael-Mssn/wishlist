class AppException implements Exception {
  AppException({
    required this.statusCode,
    required this.message,
  });

  final String message;
  final int statusCode;
}
