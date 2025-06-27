
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:core/network/dio_client.dart';
import 'package:core/network/network_info.dart';

Future<void> setupCoreDependencies(GetIt getIt) async {
  // SERVICES
  getIt.registerSingleton<DioClient>(DioClient(dio: Dio()));
  getIt.registerSingleton<NetworkInfo>(NetworkInfoImpl(Connectivity()));

  // EXTERNAL
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);
}