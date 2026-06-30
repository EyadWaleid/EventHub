import 'package:eventhub/core/service/hive/saved_event_model.dart';
import 'package:eventhub/features/profile/domain/entities/profile_entity.dart';

abstract class IProfileRepository {
  Future<ProfileEntity?> getProfile();
  Future<void> unsaveEvent(SavedEventModel event);
  Future<void> logout();
}
