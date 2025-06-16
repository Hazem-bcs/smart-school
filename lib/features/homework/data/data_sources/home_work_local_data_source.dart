import 'package:shared_preferences/shared_preferences.dart';

import '../../../../dependency_injection.dart';

abstract class HomeWorkLocalDataSource {
  Future<String?> getToken();
}

class AuthLocalDataSourceImpl implements HomeWorkLocalDataSource {
  final SharedPreferences prefs;

  AuthLocalDataSourceImpl({required this.prefs});

  @override
  Future<String?> getToken() async {
    return prefs.getString('auth_token');
  }
}
