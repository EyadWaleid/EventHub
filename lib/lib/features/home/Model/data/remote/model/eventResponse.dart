import 'dart:convert';

import 'package:eventhub/features/home/Model/data/remote/model/EventDTO.dart';

class EventResponse {
  final List<Event> events;

  EventResponse({
    required this.events,
  });

  factory EventResponse.fromJson(Map<String, dynamic> json) {
    final eventsJson = json['_embedded']?['events'] as List? ?? [];
    return EventResponse(
      events: eventsJson
          .map((e) => Event.fromJson(e))
          .toList(),
    );
  }
}
