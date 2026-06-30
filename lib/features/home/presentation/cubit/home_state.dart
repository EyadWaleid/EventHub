import 'package:eventhub/features/home/domain/entities/event_entity.dart';

abstract class HomeState {}
class HomeInitial extends HomeState {}
class HomeLoading extends HomeState {}
class HomeLoaded extends HomeState {
  final List<EventEntity> events;
  HomeLoaded(this.events);
}
class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
