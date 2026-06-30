import 'package:shared_preferences/shared_preferences.dart';


class SessionService {
  static const _keyLoggedEmail = 'logged_user_email';
  static const _keyOnboarded   = 'has_seen_onboarding';

  static Future<bool> hasSeenOnboarding() async {
    final p = await SharedPreferences.getInstance();
    return p.getBool(_keyOnboarded) ?? false;
  }

  static Future<void> markOnboardingComplete() async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_keyOnboarded, true);
  }

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
