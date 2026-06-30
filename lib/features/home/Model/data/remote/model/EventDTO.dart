import 'package:eventhub/features/home/Model/data/remote/model/EventDates.dart';
import 'package:eventhub/features/home/Model/data/remote/model/EventImageDTO.dart';
import 'package:eventhub/features/home/Model/data/remote/model/attraction.dart';
import 'package:eventhub/features/home/Model/data/remote/model/venue.dart';

class Event {
  final String id;
  final String? name;
  final String? type;
  final String? url;
  final List<EventImage>? images;
  final EventDates dates;
  final Venue? venue;
  final Attraction? attraction;
  final String? info;

  Event({
    required this.id,
    required this.name,
    required this.type,
    required this.url,
    required this.images,
    required this.dates,
    this.venue,
    this.attraction,
    this.info,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] ?? '',
      name: json['name'],
      type: json['type'],
      url: json['url'],
      info: json['info'],
      images: json['images'] != null
          ? (json['images'] as List).map((e) => EventImage.fromJson(e)).toList()
          : null,
      dates: EventDates.fromJson(json['dates']),
      venue: json['_embedded']?['venues'] != null
          ? Venue.fromJson(json['_embedded']['venues'][0])
          : null,
      attraction: json['_embedded']?['attractions'] != null
          ? Attraction.fromJson(json['_embedded']['attractions'][0])
          : null,
    );
  }
}
