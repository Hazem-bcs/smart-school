import 'package:shared_preferences/shared_preferences.dart';


abstract class NotificationLocalDataSource {
  Future<int?> getId();
}

class NotificationLocalDataSourceImpl implements NotificationLocalDataSource {
  final SharedPreferences prefs;

  NotificationLocalDataSourceImpl({required this.prefs});

  @override
  Future<int?> getId() async {
    return prefs.getInt('student_id');
  }
}
