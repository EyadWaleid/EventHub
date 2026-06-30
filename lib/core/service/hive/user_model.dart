import 'package:hive/hive.dart';
import 'hive_boxes.dart';

part 'user_model.g.dart';

@HiveType(typeId: HiveTypeIds.user)
class UserModel extends HiveObject {
  @HiveField(0) String name;
  @HiveField(1) String email;
  @HiveField(2) String password; // stored locally – hash in production!
  @HiveField(3) String? avatarUrl;

  UserModel({
    required this.name,
    required this.email,
    required this.password,
    this.avatarUrl,
  });
}
