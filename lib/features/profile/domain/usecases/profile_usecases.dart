import 'package:eventhub/core/service/hive/saved_event_model.dart';
import 'package:eventhub/features/profile/domain/entities/profile_entity.dart';
import 'package:eventhub/features/profile/domain/repo/i_profile_repository.dart';

class GetProfileUseCase {
  final IProfileRepository repo;
  GetProfileUseCase(this.repo);
  Future<ProfileEntity?> call() => repo.getProfile();
}

class UnsaveEventUseCase {
  final IProfileRepository repo;
  UnsaveEventUseCase(this.repo);
  Future<void> call(SavedEventModel event) => repo.unsaveEvent(event);
}

class LogoutUseCase {
  final IProfileRepository repo;
  LogoutUseCase(this.repo);
  Future<void> call() => repo.logout();
}
