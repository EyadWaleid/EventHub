/// Central registry of every Hive box name and TypeAdapter ID.
/// Never reuse a typeId number.
class HiveBoxes {
  HiveBoxes._();
  static const String users  = 'users';   // Box<UserModel>
  static const String events = 'events';  // Box<SavedEventModel>
}

class HiveTypeIds {
  HiveTypeIds._();
  static const int user       = 0;
  static const int savedEvent = 1;
}
