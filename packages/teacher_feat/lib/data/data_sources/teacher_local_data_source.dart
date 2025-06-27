import 'package:shared_preferences/shared_preferences.dart';


abstract class TeacherLocalDataSource {
  Future<int?> getId();
}

class TeacherLocalDataSourceImpl implements TeacherLocalDataSource {
  final SharedPreferences prefs;

  TeacherLocalDataSourceImpl({required this.prefs});

  @override
  Future<int?> getId() async {
    return prefs.getInt('student_id');
  }
}
