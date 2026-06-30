import 'package:dartz/dartz.dart';
import 'package:eventhub/core/Error/customeExceptions.dart';
import 'package:eventhub/core/Error/failure.dart';
import 'package:eventhub/features/home/Model/data/remote/model/EventDTO.dart';
import 'package:eventhub/features/home/Model/data/remote/reomteService.dart';

class EventRepo {
  final RemoteService remoteService ;
  EventRepo({required this.remoteService});
  Future<Either<Failure, List<Event>>> getEvents() async {
    try {
      final response = await remoteService.getEvent();
      return right(response.events ?? []);
    } on AppException catch (e) {
      return left(_handleException(e)) ;
    }
  }
   Failure _handleException(AppException e) {
    switch (e) {
      case NetworkException():
        return NetworkFailure(message: e.errorMessage) ;
      case UnauthorizedException():
        return UnauthorizedFailure(message: e.errorMessage);
      case NotFoundException():
        return NotFoundFailure(message: e.errorMessage);
      case ServerException():
        return ServerFailure(message: e.errorMessage);
      default:
        return ServerFailure(message: e.errorMessage);
    }
  }
}