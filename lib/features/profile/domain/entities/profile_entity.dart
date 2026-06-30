import 'package:eventhub/core/service/hive/saved_event_model.dart';

class ProfileEntity {
  final String name;
  final String email;
  final String? avatarUrl;
  final List<SavedEventModel> savedEvents;

  const ProfileEntity({
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.savedEvents,
  });
}
