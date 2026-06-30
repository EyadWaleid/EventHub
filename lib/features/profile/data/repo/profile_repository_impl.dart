import 'package:eventhub/core/service/hive/hive_service.dart';
import 'package:eventhub/core/service/hive/saved_event_model.dart';
import 'package:eventhub/core/service/hive/session_service.dart';
import 'package:eventhub/features/profile/domain/entities/profile_entity.dart';
import 'package:eventhub/features/profile/domain/repo/i_profile_repository.dart';

class ProfileRepositoryImpl implements IProfileRepository {
  @override
  Future<ProfileEntity?> getProfile() async {
    final email = await SessionService.getLoggedEmail();
    if (email == null) return null;

    final user = HiveService.findUser(email);
    if (user == null) return null;

    final saved = HiveService.getSavedEvents(email);

    return ProfileEntity(
      name: user.name,
      email: user.email,
      avatarUrl: user.avatarUrl,
      savedEvents: saved,
    );
  }

  @override
  Future<void> unsaveEvent(SavedEventModel event) async {
    await HiveService.toggleSave(event); // toggleSave deletes if already saved
  }

  @override
  Future<void> logout() async {
    await SessionService.logout();
  }
}
