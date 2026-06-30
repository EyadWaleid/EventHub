import 'package:shared_preferences/shared_preferences.dart';

class  PrefsService {
  static const String _keyHasSeenOnboarding = 'has_seen_onboarding';
  static const String _keyHasLogin = "has_seen_logged";
  static Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyHasSeenOnboarding) ?? false;
  }
  static Future<bool> hasSeenLogged() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyHasLogin) ?? false;
  }


  static Future<void> markOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyHasSeenOnboarding, true);
  }
  static Future<void> markLoggedComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyHasLogin, true);
  }

  static Future<void> resetOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyHasSeenOnboarding);
  }

}
