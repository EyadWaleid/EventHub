import 'package:dio/dio.dart';
import 'package:eventhub/lib/features/home/Model/data/remote/model/EventDTO.dart';
import 'package:eventhub/lib/features/home/Model/data/remote/url.dart';
import 'package:eventhub/lib/features/home/domain/entities/event_entity.dart';


/// Thin data-source the UI calls directly via FutureBuilder.
/// No state management — just async methods that return data.
class EventDataSource {
  EventDataSource._();

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: Secrets.baseUrl,
      queryParameters: {'apikey': Secrets.apiKey},
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  // ── public API ──────────────────────────────────────────────────────

  static Future<List<EventEntity>> getEvents() async {
    final res = await _dio.get('/events.json',
        queryParameters: {'countryCode': 'US', 'size': 20});
    return _parseEvents(res.data);
  }

  static Future<List<EventEntity>> searchEvents(String keyword) async {
    final res = await _dio.get('/events.json',
        queryParameters: {'countryCode': 'US', 'keyword': keyword, 'size': 20});
    return _parseEvents(res.data);
  }

  static Future<List<EventEntity>> searchByCategory(
      String category, String keyword) async {
    final res = await _dio.get('/events.json', queryParameters: {
      'countryCode': 'US',
      'classificationName': category,
      'keyword': keyword,
      'size': 20,
    });
    return _parseEvents(res.data);
  }

  // ── helpers ─────────────────────────────────────────────────────────

  static List<EventEntity> _parseEvents(dynamic json) {
    final raw = (json as Map<String, dynamic>)['_embedded']?['events'] as List? ?? [];
    return raw.map((e) => _toEntity(Event.fromJson(e))).toList();
  }

  static EventEntity _toEntity(Event dto) {
    final sorted = List.of(dto.images as Iterable<dynamic>)..sort((a, b) => b.width.compareTo(a.width));
    final img = sorted.firstWhere((i) => i.ratio == '16_9',
        orElse: () => sorted.first);

    DateTime date;
    try {
      date = DateTime.parse(dto.dates.localDate);
    } catch (_) {
      date = DateTime.now();
    }

    return EventEntity(
      id: dto.id,
      name: dto.name ?? "Unknown",
      type: dto.type ?? "Unknown",
      url: dto.url ?? "https://community.softr.io/t/request-for-adding-placeholder-image-functionality-in-list-views/4013" ,
      imageUrl: img.url,
      startDate: date,
      localTime: dto.dates.localTime,
      timezone: dto.dates.timezone ?? DateTime.now().timeZoneName,
      status: dto.dates.status,
      venueName: dto.venue?.name,
      venueCity: dto.venue?.city,
      venueAddress: dto.venue?.address,
      attractionName: dto.attraction?.name,
      info: dto.info,
    );
  }
}
