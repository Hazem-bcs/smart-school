import 'package:shared_preferences/shared_preferences.dart';

import '../../../../dependency_injection.dart';

abstract class ProfileLocalDataSource {
  Future<int?> getId();
}

class AuthLocalDataSourceImpl implements ProfileLocalDataSource {
  final SharedPreferences prefs;

  AuthLocalDataSourceImpl({required this.prefs});

  @override
  Future<int?> getId() async {
    return prefs.getInt('student_id');
  }
}
