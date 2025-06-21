import 'package:shared_preferences/shared_preferences.dart';

import '../../../../dependency_injection.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheId(int token);
  Future<int?> getId();
  // on Boarding
  Future<bool> hasSeenOnboarding();
  Future<void> cacheOnboardingStatus();

}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences prefs;

  AuthLocalDataSourceImpl({required this.prefs});

  @override
  Future<void> cacheId(int studentId) async {
    await getIt<SharedPreferences>().setInt('student_id', studentId);
  }

  @override
  Future<int?> getId() async {
    return prefs.getInt('student_id');
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
