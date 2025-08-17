import 'package:shared_preferences/shared_preferences.dart';

abstract class DuesLocalDataSource {
  Future<int?> getId();
}

class DuesLocalDataSourceImpl implements DuesLocalDataSource {
  final SharedPreferences prefs;

  DuesLocalDataSourceImpl({required this.prefs});

  @override
  Future<int?> getId() async {
    return prefs.getInt('user_id'); // نفس key المستخدم في auth package
  }
}
