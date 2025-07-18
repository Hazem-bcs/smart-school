

import 'package:core/network/failures.dart';
import 'package:shared_preferences/shared_preferences.dart';


abstract class SettingsLocalDataSource {
  Future<String?> getAuthToken();

  Future<void> cacheAuthToken(String token);

  Future<void> clearAuthToken();
}

const String CACHED_AUTH_TOKEN = 'auth_token';

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final SharedPreferences sharedPreferences;

  SettingsLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<String?> getAuthToken() async {
    try {
      return sharedPreferences.getString(CACHED_AUTH_TOKEN);
    } catch (e) {
      throw CacheFailure(
        message: "فشل ${e.toString()}",
      );
    }
  }

  @override
  Future<void> cacheAuthToken(String token) async {
    try {
      await sharedPreferences.setString(CACHED_AUTH_TOKEN, token);
    } catch (e) {
      throw CacheFailure(
        message: "فشل ${e.toString()}",
      );
    }
  }

  @override
  Future<void> clearAuthToken() async {
    try {
      await sharedPreferences.remove(CACHED_AUTH_TOKEN);
    } catch (e) {
      throw CacheFailure(
        message: "فشل  ${e.toString()}",
      );
    }
  }
}
