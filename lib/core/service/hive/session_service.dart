import 'package:shared_preferences/shared_preferences.dart';

/// Lightweight session layer on top of SharedPreferences.
/// Stores the currently logged-in user's email so the app knows
/// who is signed in across cold restarts.
class SessionService {
  static const _keyLoggedEmail = 'logged_user_email';
  static const _keyOnboarded   = 'has_seen_onboarding';

  // ── Onboarding ─────────────────────────────────────────────────────
  static Future<bool> hasSeenOnboarding() async {
    final p = await SharedPreferences.getInstance();
    return p.getBool(_keyOnboarded) ?? false;
  }

  static Future<void> markOnboardingComplete() async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_keyOnboarded, true);
  }

  // ── Auth session ────────────────────────────────────────────────────
  static Future<void> saveSession(String email) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_keyLoggedEmail, email);
  }

  static Future<String?> getLoggedEmail() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(_keyLoggedEmail);
  }

  static Future<bool> isLoggedIn() async =>
      (await getLoggedEmail()) != null;

  static Future<void> logout() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(_keyLoggedEmail);
  }
}
