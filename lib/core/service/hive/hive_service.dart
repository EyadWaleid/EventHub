import 'package:hive_flutter/hive_flutter.dart';
import 'hive_boxes.dart';
import 'saved_event_model.dart';
import 'user_model.dart';

/// One-stop shop for all Hive operations.
/// No state management – every method is static and reads/writes directly.
class HiveService {
  // ── Init ──────────────────────────────────────────────────────────────

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(SavedEventModelAdapter());
    await Hive.openBox<UserModel>(HiveBoxes.users);
    await Hive.openBox<SavedEventModel>(HiveBoxes.events);
  }

  // ── Auth helpers ──────────────────────────────────────────────────────

  static Box<UserModel> get _users => Hive.box<UserModel>(HiveBoxes.users);

  /// Returns the registered user for [email], or null.
  static UserModel? findUser(String email) {
    try {
      return _users.values.firstWhere(
        (u) => u.email.toLowerCase() == email.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  /// Register a new user. Returns false if the email is already taken.
  static Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    if (findUser(email) != null) return false;
    await _users.add(UserModel(name: name, email: email, password: password));
    return true;
  }

  /// Returns the user if credentials match, otherwise null.
  static UserModel? login({required String email, required String password}) {
    final user = findUser(email);
    if (user != null && user.password == password) return user;
    return null;
  }

  // ── Saved-events helpers ──────────────────────────────────────────────

  static Box<SavedEventModel> get _events =>
      Hive.box<SavedEventModel>(HiveBoxes.events);

  /// All events saved by [userEmail].
  static List<SavedEventModel> getSavedEvents(String userEmail) =>
      _events.values
          .where((e) => e.userEmail == userEmail)
          .toList();

  /// Whether [eventId] is already saved by [userEmail].
  static bool isSaved(String eventId, String userEmail) =>
      _events.values.any(
        (e) => e.id == eventId && e.userEmail == userEmail,
      );

  /// Toggle save/unsave. Returns the new saved state (true = saved).
  static Future<bool> toggleSave(SavedEventModel model) async {
    final existing = _events.values.firstWhere(
      (e) => e.id == model.id && e.userEmail == model.userEmail,
      orElse: () => SavedEventModel(
          id: '', name: '', imageUrl: '', location: '',
          formattedDate: '', localTime: '', type: '', userEmail: ''),
    );

    if (existing.id.isNotEmpty) {
      await existing.delete();
      return false;
    } else {
      await _events.add(model);
      return true;
    }
  }
}
