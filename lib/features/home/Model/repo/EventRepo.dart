import 'package:dartz/dartz.dart';
import 'package:eventhub/core/Error/customeExceptions.dart';
import 'package:eventhub/core/Error/failure.dart';
import 'package:eventhub/features/home/Model/data/remote/remote_data_soruce/IEventDataSource.dart';
import 'package:eventhub/features/home/domain/entities/event_entity.dart';
import 'package:eventhub/features/home/domain/repo/i_event_repository.dart';

class EventRepositoryImpl implements IEventRepository {
  final IEventDataSource eventDataSource;

  EventRepositoryImpl(this.eventDataSource);

  @override
  Future<Either<Failure, List<EventEntity>>> getEvents() async {
    try {
      final events = await eventDataSource.getEvents();
      return right(events);
    } on AppException catch (e) {
      return left(_mapException(e));
    }
  }

  @override
  Future<Either<Failure, List<EventEntity>>> searchEvents(String keyword) async {
    try {
      final events = await eventDataSource.searchEvents(keyword);
      return right(events);
    } on AppException catch (e) {
      return left(_mapException(e));
    }
  }

  @override
  Future<Either<Failure, List<EventEntity>>> searchEventsByCategory(
      String category, String keyword) async {
    try {
      final events = await eventDataSource.searchByCategory(category, keyword);
      return right(events);
    } on AppException catch (e) {
      return left(_mapException(e));
    }
  }

  Failure _mapException(AppException e) {
    if (e is NetworkException) return NetworkFailure(message: e.errorMessage);
    if (e is UnauthorizedException) return UnauthorizedFailure(message: e.errorMessage);
    if (e is NotFoundException) return NotFoundFailure(message: e.errorMessage);
    return ServerFailure(message: e.errorMessage);
  }
}