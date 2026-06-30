import 'package:dio/dio.dart';
import 'package:eventhub/core/service/hive/hive_service.dart';
import 'package:eventhub/features/home/Model/data/remote/remote_data_soruce/event_data_source.dart';
import 'package:eventhub/features/home/Model/data/remote/remote_data_soruce/url.dart';
import 'package:eventhub/features/home/Model/repo/EventRepo.dart';
import 'package:eventhub/features/home/domain/repo/i_event_repository.dart';
import 'package:eventhub/features/home/domain/usecases/event_usecases.dart';
import 'package:eventhub/features/profile/data/repo/profile_repository_impl.dart';
import 'package:eventhub/features/profile/domain/repo/i_profile_repository.dart';
import 'package:eventhub/features/profile/domain/usecases/profile_usecases.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerLazySingleton<Dio>(() => Dio(
    BaseOptions(
      baseUrl: Secrets.baseUrl,
      queryParameters: {'apikey': Secrets.apiKey},
    ),
  ));

  getIt.registerLazySingleton<EventDataSourceImpl>(
          () => EventDataSourceImpl(getIt<Dio>()));

  getIt.registerLazySingleton<IEventRepository>(
          () => EventRepositoryImpl(getIt<EventDataSourceImpl>()));

  getIt.registerLazySingleton(
          () => GetEventsUseCase(getIt<IEventRepository>()));
  getIt.registerLazySingleton(
          () => SearchEventsUseCase(getIt<IEventRepository>()));
  getIt.registerLazySingleton(
          () => SearchEventsByCategoryUseCase(getIt<IEventRepository>()));


  getIt.registerLazySingleton<IProfileRepository>(
          () => ProfileRepositoryImpl());

  getIt.registerLazySingleton(
          () => GetProfileUseCase(getIt<IProfileRepository>()));
  getIt.registerLazySingleton(
          () => UnsaveEventUseCase(getIt<IProfileRepository>()));
  getIt.registerLazySingleton(
          () => LogoutUseCase(getIt<IProfileRepository>()));


}