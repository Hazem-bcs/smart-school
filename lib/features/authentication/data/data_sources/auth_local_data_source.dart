import 'package:shared_preferences/shared_preferences.dart';

import '../../../../dependency_injection.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheToken(String token);
  Future<String?> getToken();
  // on Boarding
  Future<bool> hasSeenOnboarding();
  Future<void> cacheOnboardingStatus();

}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences prefs;

  AuthLocalDataSourceImpl({required this.prefs});

  @override
  Future<void> cacheToken(String token) async {
    await getIt<SharedPreferences>().setString('auth_token', token);
  }

  @override
  Future<String?> getToken() async {
    return prefs.getString('auth_token');
  }

  @override
  Future<bool> hasSeenOnboarding() async {
    print('herrrrreeeeeeeeeeeeee');
    print(prefs.getBool('on_boarding_viewed'));
    return prefs.getBool('on_boarding_viewed') ?? false;
  }

  @override
  Future<void> cacheOnboardingStatus() async {
    print('-------------------------ok--------------------------');
    await prefs.setBool('on_boarding_viewed', true);
    print(prefs.getBool('on_boarding_viewed'));
  }
}
