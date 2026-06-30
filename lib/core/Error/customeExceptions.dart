class UnauthorizedException extends AppException {
  UnauthorizedException({required super.errorMessage});
}

class AppException implements Exception{
  final String errorMessage;
  AppException({required this.errorMessage});
}

class NotFoundException extends AppException {
  NotFoundException({required super.errorMessage});
}
class ServerException extends AppException {
  ServerException({required super.errorMessage});
}
class NetworkException extends AppException {
  NetworkException({required super.errorMessage});
}