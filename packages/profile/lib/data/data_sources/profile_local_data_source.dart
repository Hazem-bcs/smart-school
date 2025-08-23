

import 'package:shared_preferences/shared_preferences.dart';

abstract class ProfileLocalDataSource {
  Future<int?> getId();
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final SharedPreferences prefs;

  ProfileLocalDataSourceImpl({required this.prefs});

  @override
  Future<int?> getId() async {
    return prefs.getInt('user_id');
  }
}
