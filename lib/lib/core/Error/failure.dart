abstract class Failure {
  final String message;
  Failure({required this.message});
}

class ServerFailure extends Failure {
  ServerFailure({required super.message});
}

class NetworkFailure extends Failure {
  NetworkFailure({required super.message});
}

class CacheFailure extends Failure {
  CacheFailure({required super.message});
}
class UnauthorizedFailure extends Failure {
  UnauthorizedFailure({required super.message});
}
class NotFoundFailure extends Failure {
  NotFoundFailure({required super.message});
}