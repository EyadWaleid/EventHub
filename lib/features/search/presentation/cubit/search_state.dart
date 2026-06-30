import 'package:eventhub/features/home/domain/entities/event_entity.dart';

abstract class SearchState {}
class SearchIdle extends SearchState {}
class SearchLoading extends SearchState {}
class SearchLoaded extends SearchState {
  final List<EventEntity> results;
  SearchLoaded(this.results);
}
class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
}
