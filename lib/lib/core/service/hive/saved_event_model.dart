import 'package:hive/hive.dart';
import 'hive_boxes.dart';

part 'saved_event_model.g.dart';

@HiveType(typeId: HiveTypeIds.savedEvent)
class SavedEventModel extends HiveObject {
  @HiveField(0) String id;
  @HiveField(1) String name;
  @HiveField(2) String imageUrl;
  @HiveField(3) String location;
  @HiveField(4) String formattedDate;
  @HiveField(5) String localTime;
  @HiveField(6) String type;
  @HiveField(7) String userEmail;

  SavedEventModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.location,
    required this.formattedDate,
    required this.localTime,
    required this.type,
    required this.userEmail,
  });
}
