import 'package:shared_preferences/shared_preferences.dart';


abstract class SubjectLocalDataSource {
  Future<String?> getToken();
}

class SubjectLocalDataSourceImpl implements SubjectLocalDataSource {
  final SharedPreferences prefs;

  SubjectLocalDataSourceImpl({required this.prefs});

  @override
  Future<String?> getToken() async {
    return prefs.getString('auth_token');
  }

}
