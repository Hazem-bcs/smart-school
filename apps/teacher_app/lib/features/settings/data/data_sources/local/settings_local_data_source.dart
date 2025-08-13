import 'package:core/network/failures.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsLocalDataSource {
  Future<String?> getUserId();
  Future<void> clearUserId();
  Future<void> cacheUserId(String userId);
}

const String cachedUserId = 'user_id';

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final SharedPreferences sharedPreferences;

  SettingsLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<String?> getUserId() async {
    try {
      String? userId = sharedPreferences.getString(cachedUserId);  
      return userId;
    } catch (e) {
      throw CacheFailure(message: "فشل في جلب معرف المستخدم: ${e.toString()}");
    }
  }

  @override
  Future<void> clearUserId() async {
    try {
      await sharedPreferences.remove(cachedUserId);
    } catch (e) {
      throw CacheFailure(message: "فشل في مسح معرف المستخدم: ${e.toString()}");
    }
  }

  @override
  Future<void> cacheUserId(String userId) async {
    try {
      // Always store as string to ensure consistency
      await sharedPreferences.setString(cachedUserId, userId);
    } catch (e) {
      throw CacheFailure(message: "فشل في حفظ معرف المستخدم: ${e.toString()}");
    }
  }
} 