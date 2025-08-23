import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsLocalDataSource {
  Future<int?> getId();
  Future<void> clearId();
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final SharedPreferences prefs;

  SettingsLocalDataSourceImpl({required this.prefs});
  @override
  Future<int?> getId() async {
    return prefs.getInt('user_id');
  }

  @override
  Future<void> clearId() async {
    await prefs.remove('user_id');
  }
}
