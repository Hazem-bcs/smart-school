import 'package:shared_preferences/shared_preferences.dart';


abstract class NewAssignmentLocalDataSource {
  Future<int?> getId();
}

class NewAssignmentLocalDataSourceImpl implements NewAssignmentLocalDataSource {
  final SharedPreferences prefs;

  NewAssignmentLocalDataSourceImpl({required this.prefs});

  @override
  Future<int?> getId() async {
    return prefs.getInt('user_id');
  }
}
