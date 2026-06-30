import 'package:dartz/dartz.dart';
import 'package:eventhub/lib/core/Error/failure.dart';
import 'package:eventhub/lib/features/home/domain/entities/event_entity.dart';

abstract class IEventRepository {
  Future<Either<Failure, List<EventEntity>>> getEvents();
  Future<Either<Failure, List<EventEntity>>> searchEvents(String keyword);
  Future<Either<Failure, List<EventEntity>>> searchEventsByCategory(
      String category, String keyword);
}
