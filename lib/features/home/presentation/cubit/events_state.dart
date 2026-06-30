import 'package:eventhub/features/home/domain/entities/event_entity.dart';

abstract class EventsState {}
class EventsInitial extends EventsState {}
class EventsLoading extends EventsState {}
class EventsLoaded extends EventsState {
  final List<EventEntity> upcoming;
  final List<EventEntity> latest;
  EventsLoaded({required this.upcoming, required this.latest});
}
class EventsError extends EventsState {
  final String message;
  EventsError(this.message);
}
