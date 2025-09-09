import 'package:shared_preferences/shared_preferences.dart';

abstract class ScheduleLocalDataSource {
  Future<int?> getId();
  Future<void> clearId();
}

class ScheduleLocalDataSourceImpl implements ScheduleLocalDataSource {
  final SharedPreferences prefs;

  ScheduleLocalDataSourceImpl({required this.prefs});
  @override
  Future<int?> getId() async {
    return prefs.getInt('user_id');
  }

  @override
  Future<void> clearId() async {
    await prefs.remove('user_id');
  }
}
