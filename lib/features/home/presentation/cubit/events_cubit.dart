import 'package:eventhub/core/service/hive/saved_event_model.dart';
import 'package:eventhub/features/home/domain/entities/event_entity.dart';
import 'package:eventhub/features/home/domain/usecases/event_usecases.dart';
import 'package:eventhub/features/home/presentation/cubit/events_state.dart';
import 'package:eventhub/features/profile/domain/usecases/profile_usecases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventsCubit extends Cubit<EventsState> {
  final GetEventsUseCase getEventsUseCase;
  final GetProfileUseCase getProfileUseCase;
  final UnsaveEventUseCase unsaveEventUseCase;

  String? _userEmail;
  Set<String> savedIds = {};

  EventsCubit({
    required this.getEventsUseCase,
    required this.getProfileUseCase,
    required this.unsaveEventUseCase,
  }) : super(EventsInitial());

  Future<void> init() async {
    final profile = await getProfileUseCase();
    if (profile != null) {
      _userEmail = profile.email;
      savedIds = profile.savedEvents.map((e) => e.id).toSet();
    }
    await loadEvents();
  }

  Future<void> loadEvents() async {
    emit(EventsLoading());
    final result = await getEventsUseCase();
    result.fold(
          (f) => emit(EventsError(f.message)),
          (all) {
        final now = DateTime.now();
        final upcoming = all
            .where((e) =>
        e.startDate.isAfter(now) &&
            e.startDate.isBefore(now.add(const Duration(days: 7))))
            .toList()
          ..sort((a, b) => a.startDate.compareTo(b.startDate));
        final latest = all
            .where((e) =>
        e.startDate.isBefore(now) &&
            e.startDate.isAfter(now.subtract(const Duration(days: 7))))
            .toList()
          ..sort((a, b) => b.startDate.compareTo(a.startDate));
        emit(EventsLoaded(upcoming: upcoming, latest: latest));
      },
    );
  }

  Future<void> toggleSave(EventEntity event) async {
    if (_userEmail == null) return;
    final model = SavedEventModel(
      id: event.id,
      name: event.name,
      imageUrl: event.imageUrl,
      location: event.location,
      formattedDate: event.formattedDate,
      localTime: event.localTime,
      type: event.type,
      userEmail: _userEmail!,
    );

    await unsaveEventUseCase(model);

    if (savedIds.contains(event.id)) {
      savedIds.remove(event.id);
    } else {
      savedIds.add(event.id);
    }

    final current = state;
    if (current is EventsLoaded) {
      emit(EventsLoaded(upcoming: current.upcoming, latest: current.latest));
    }
  }
}