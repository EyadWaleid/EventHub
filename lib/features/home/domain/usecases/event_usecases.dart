import 'package:dartz/dartz.dart';
import 'package:eventhub/core/Error/failure.dart';
import 'package:eventhub/features/home/domain/entities/event_entity.dart';
import 'package:eventhub/features/home/domain/repo/i_event_repository.dart';

class GetEventsUseCase {
  final IEventRepository repository;
  GetEventsUseCase(this.repository);

  Future<Either<Failure, List<EventEntity>>> call() {
    return repository.getEvents();
  }
}

class SearchEventsUseCase {
  final IEventRepository repository;
  SearchEventsUseCase(this.repository);

  Future<Either<Failure, List<EventEntity>>> call(String keyword) {
    return repository.searchEvents(keyword);
  }
}

class SearchEventsByCategoryUseCase {
  final IEventRepository repository;
  SearchEventsByCategoryUseCase(this.repository);

  Future<Either<Failure, List<EventEntity>>> call(
      String category, String keyword) {
    return repository.searchEventsByCategory(category, keyword);
  }
}
