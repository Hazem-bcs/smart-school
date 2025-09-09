import 'package:shared_preferences/shared_preferences.dart';


abstract class AttendanceLocalDataSource {
  Future<int?> getId();
}

class AttendanceLocalDataSourceImpl implements AttendanceLocalDataSource {
  final SharedPreferences prefs;

  AttendanceLocalDataSourceImpl({required this.prefs});

  @override
  Future<int?> getId() async {
    // Some features use 'user_id', others 'student_id'. Try both.
    return prefs.getInt('student_id') ?? prefs.getInt('user_id');
  }
}


