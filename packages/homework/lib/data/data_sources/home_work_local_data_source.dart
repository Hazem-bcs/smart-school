import 'package:shared_preferences/shared_preferences.dart';


abstract class HomeWorkLocalDataSource {
  Future<int?> getId();
}

class HomeWorkLocalDataSourceImpl implements HomeWorkLocalDataSource {
  final SharedPreferences prefs;

  HomeWorkLocalDataSourceImpl({required this.prefs});

  @override
  Future<int?> getId() async {
    return prefs.getInt('student_id');
  }
}
