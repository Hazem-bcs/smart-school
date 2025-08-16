import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheId(int token);
  Future<int?> getId();
  Future<void> clearId();
  // on Boarding
  Future<bool> hasSeenOnboarding();
  Future<void> cacheOnboardingStatus();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences prefs;

  AuthLocalDataSourceImpl({required this.prefs});

  @override
  Future<void> cacheId(int userId) async {
    await prefs.setInt('user_id', userId);
  }

  @override
  Future<int?> getId() async {
    return prefs.getInt('user_id');
  }

  @override
  Future<void> clearId() async {
    await prefs.remove('user_id');
  }

  @override
  Future<bool> hasSeenOnboarding() async {
    return prefs.getBool('on_boarding_viewed') ?? false;
  }

  @override
  Future<void> cacheOnboardingStatus() async {
    await prefs.setBool('on_boarding_viewed', true);
  }
}
