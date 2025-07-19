import 'package:shared_preferences/shared_preferences.dart';
// ToDo: here shared a local data in core for all feature
abstract class LocalDataSource {
  Future<void> saveId(int userId);
  Future<int?> getUserId();
   Future<void> clearUserId();
}

class LocalDataSourceImpl implements LocalDataSource {

  @override
  Future<void> saveId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_id',userId);
  }

  @override
  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

    @override
  Future<void> clearUserId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
  }
} 