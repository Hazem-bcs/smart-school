import 'package:shared_preferences/shared_preferences.dart';


abstract class SubjectLocalDataSource {
  Future<int?> getId();
}

class SubjectLocalDataSourceImpl implements SubjectLocalDataSource {
  final SharedPreferences prefs;

  SubjectLocalDataSourceImpl({required this.prefs});

  @override
  Future<int?> getId() async {
    return prefs.getInt('user_id');
  }

}
