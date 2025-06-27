import 'package:shared_preferences/shared_preferences.dart';


abstract class ResourceLocalDataSource {
  Future<int?> getId();
}

class ResourceLocalDataSourceImpl implements ResourceLocalDataSource {
  final SharedPreferences prefs;

  ResourceLocalDataSourceImpl({required this.prefs});

  @override
  Future<int?> getId() async {
    return prefs.getInt('student_id');
  }
}
