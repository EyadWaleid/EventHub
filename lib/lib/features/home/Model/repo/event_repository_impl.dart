import 'package:dartz/dartz.dart';
import 'package:eventhub/core/Error/customeExceptions.dart';
import 'package:eventhub/core/Error/failure.dart';
import 'package:eventhub/features/home/Model/data/remote/eventeService.dart';
import 'package:eventhub/features/home/Model/data/remote/model/EventDTO.dart';
import 'package:eventhub/features/home/domain/entities/event_entity.dart';
import 'package:eventhub/features/home/domain/repo/i_event_repository.dart';

class EventRepositoryImpl implements IEventRepository {
  final EventService eventService;

  EventRepositoryImpl(this.eventService);

  @override
  Future<Either<Failure, List<EventEntity>>> getEvents() async {
    try {
      final response = await eventService.getEvent();
      final entities = response.events
          .map(_toEntity)
          .whereType<EventEntity>() // drops any that returned null
          .toList();
      return right(entities);
    } on AppException catch (e) {
      return left(_mapException(e));
    }
  }

  @override
  Future<Either<Failure, List<EventEntity>>> searchEvents(String keyword) async {
    try {
      final response = await eventService.getSearchedEvents(keyword);
      final entities = response.events
          .map(_toEntity)
          .whereType<EventEntity>()
          .toList();
      return right(entities);
    } on AppException catch (e) {
      return left(_mapException(e));
    }
  }

  @override
  Future<Either<Failure, List<EventEntity>>> searchEventsByCategory(
      String category, String keyword) async {
    try {
      final response =
          await eventService.getSearchedEventsByCatagories(category, keyword);
      final entities = response.events
          .map(_toEntity)
          .whereType<EventEntity>()
          .toList();
      return right(entities);
    } on AppException catch (e) {
      return left(_mapException(e));
    }
  }

  // returns null if the event has no usable image — filtered out above
  EventEntity? _toEntity(Event dto) {
    final images = dto.images;
    if (images == null || images.isEmpty) return null;

    // pick best image: largest 16_9, fallback to largest overall
    final sorted = List.of(images)..sort((a, b) => b.width.compareTo(a.width));
    final best = sorted.firstWhere(
      (img) => img.ratio == '16_9',
      orElse: () => sorted.first,
    );

    DateTime startDate;
    try {
      startDate = DateTime.parse(dto.dates.localDate);
    } catch (_) {
      startDate = DateTime.now();
    }

    return EventEntity(
      id: dto.id,
      name: dto.name ?? 'Untitled Event',
      type: dto.type ?? 'event',
      url: dto.url ?? '',
      imageUrl: best.url,
      startDate: startDate,
      localTime: dto.dates.localTime,
      timezone: dto.dates.timezone ?? '',
      status: dto.dates.status,
      venueName: dto.venue?.name,
      venueCity: dto.venue?.city,
      venueAddress: dto.venue?.address,
      attractionName: dto.attraction?.name,
      info: dto.info,
    );
  }

  Failure _mapException(AppException e) {
    if (e is NetworkException) return NetworkFailure(message: e.errorMessage);
    if (e is UnauthorizedException) return UnauthorizedFailure(message: e.errorMessage);
    if (e is NotFoundException) return NotFoundFailure(message: e.errorMessage);
    return ServerFailure(message: e.errorMessage);
  }
}
