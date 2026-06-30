import 'package:eventhub/features/home/Model/data/remote/model/EventDTO.dart';
import 'package:eventhub/features/home/domain/entities/event_entity.dart';

abstract class IEventDataSource {
  Future<List<EventEntity>> getEvents();
  Future<List<EventEntity>> searchEvents(String keyword);
  Future<List<EventEntity>> searchByCategory(String category, String keyword);
}