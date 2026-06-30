import 'package:dio/dio.dart';
import 'package:eventhub/core/Error/customeExceptions.dart';
import 'package:eventhub/features/home/Model/data/remote/model/EventDTO.dart';
import 'package:eventhub/features/home/Model/data/remote/remote_data_soruce/IEventDataSource.dart';
import 'package:eventhub/features/home/domain/entities/event_entity.dart';

class EventDataSourceImpl implements IEventDataSource {
  final Dio _dio;

  EventDataSourceImpl(this._dio);

  Never _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        throw NetworkException(errorMessage: 'No internet connection');

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        switch (statusCode) {
          case 401:
            throw UnauthorizedException(errorMessage: 'Unauthorized');
          case 404:
            throw NotFoundException(errorMessage: 'Resource not found');
          case 500:
            throw ServerException(errorMessage: 'Internal server error');
          default:
            throw ServerException(errorMessage: 'Bad response: $statusCode');
        }

      case DioExceptionType.cancel:
        throw NetworkException(errorMessage: 'Request cancelled');

      default:
        throw ServerException(errorMessage: e.message ?? 'Unknown error');
    }
  }

  @override
  Future<List<EventEntity>> getEvents() async {
    try {
      final res = await _dio.get('/events.json',
          queryParameters: {'countryCode': 'US', 'size': 20});
      return _parseEvents(res.data);
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      throw ServerException(errorMessage: 'An unexpected error occurred: $e');
    }
  }

  @override
  Future<List<EventEntity>> searchEvents(String keyword) async {
    try {
      final res = await _dio.get('/events.json', queryParameters: {
        'countryCode': 'US',
        'keyword': keyword,
        'size': 20,
      });
      return _parseEvents(res.data);
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      throw ServerException(errorMessage: 'An unexpected error occurred: $e');
    }
  }

  @override
  Future<List<EventEntity>> searchByCategory(
      String category, String keyword) async {
    try {
      final res = await _dio.get('/events.json', queryParameters: {
        'countryCode': 'US',
        'classificationName': category,
        'keyword': keyword,
        'size': 20,
      });
      return _parseEvents(res.data);
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      throw ServerException(errorMessage: 'An unexpected error occurred: $e');
    }
  }

  List<EventEntity> _parseEvents(dynamic json) {
    final raw = (json as Map<String, dynamic>)['_embedded']?['events'] as List? ?? [];
    final events = raw.map((e) => _toEntity(Event.fromJson(e))).toList();
    final sortedEvents = List.of(events)
      ..sort((a, b) => a.startDate.compareTo(b.startDate));
    return sortedEvents;
  }

  EventEntity _toEntity(Event dto) {
    final sorted = List.of(dto.images as Iterable<dynamic>)
      ..sort((a, b) => b.width.compareTo(a.width));
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
      url: dto.url ??
          "https://community.softr.io/t/request-for-adding-placeholder-image-functionality-in-list-views/4013",
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