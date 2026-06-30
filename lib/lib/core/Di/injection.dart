import 'package:dio/dio.dart';
import 'package:eventhub/lib/features/home/Model/data/remote/eventeService.dart';
import 'package:eventhub/lib/features/home/Model/data/remote/url.dart';
import 'package:eventhub/lib/features/home/Model/repo/event_repository_impl.dart';
import 'package:eventhub/lib/features/home/domain/repo/i_event_repository.dart';
import 'package:eventhub/lib/features/home/domain/usecases/event_usecases.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // ── Network ──────────────────────────────────────────────────────────
  getIt.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        baseUrl: Secrets.baseUrl,
        queryParameters: {'apikey': Secrets.apiKey},
      ),
    ),
  );

  // ── Data layer ───────────────────────────────────────────────────────
  getIt.registerLazySingleton<EventService>(
    () => EventService(getIt<Dio>()),
  );

  getIt.registerLazySingleton<IEventRepository>(
    () => EventRepositoryImpl(getIt<EventService>()),
  );

  // ── Use cases ─────────────────────────────────────────────────────────
  getIt.registerLazySingleton(
    () => GetEventsUseCase(getIt<IEventRepository>()),
  );

  getIt.registerLazySingleton(
    () => SearchEventsUseCase(getIt<IEventRepository>()),
  );

  getIt.registerLazySingleton(
    () => SearchEventsByCategoryUseCase(getIt<IEventRepository>()),
  );
}
