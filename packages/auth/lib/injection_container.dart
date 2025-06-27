import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:core/network/dio_client.dart';
import 'package:core/network/network_info.dart';

import 'data/auth_repository_impl.dart';
import 'data/data_sources/auth_local_data_source.dart';
import 'data/data_sources/auth_remote_data_source.dart';
import 'domain/auth_repository.dart';
import 'domain/usecases/cheakauthstatus_usecase.dart';
import 'domain/usecases/login_usecase.dart';

Future<void> setupAuthDependencies(GetIt getIt) async {
  // --------------------------  D A T A S O U R C E S   -----------------------------------
  getIt.registerSingleton<AuthRemoteDataSource>(
      AuthRemoteDataSourceImpl(dioClient: getIt<DioClient>()));

  // --------------------------  S  H  A  R  E  D  P  R  E  F   -----------------------------------

  getIt.registerSingleton<AuthLocalDataSource>(
      AuthLocalDataSourceImpl(prefs: getIt<SharedPreferences>()));

  // --------------------------  R E P O S I T O R Y   -----------------------------------
  getIt.registerSingleton<AuthRepository>(AuthRepositoryImpl(
    remoteDataSource: getIt<AuthRemoteDataSource>(),
    localDataSource: getIt<AuthLocalDataSource>(),
    networkInfo: getIt<NetworkInfo>(),
  ));

  // --------------------------  U S E C A S E S   -----------------------------------
  getIt.registerFactory(() => LoginUseCase(getIt<AuthRepository>()));
  getIt.registerFactory(() => CheckAuthStatusUseCase(getIt<AuthRepository>()));

}