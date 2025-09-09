
import 'package:core/network/dio_client.dart';
import 'package:core/network/network_info.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/data_sources/profile_local_data_source.dart';
import 'data/data_sources/profile_remote_data_source.dart';
import 'data/profile_repository_impl.dart';
import 'domain/profile_repository.dart';
import 'domain/use_cases/get_user_profile_use_case.dart';


Future<void> setupProfileDependencies(GetIt getIt) async {

  // --------------------------  D A T A S O U R C E S   -----------------------------------

  getIt.registerSingleton<ProfileRemoteDataSource>(
      ProfileRemoteDataSourceImpl(dioClient: getIt<DioClient>())
  );

  // --------------------------  S  H  A  R  E  D  P  R  E  F   -----------------------------------

  getIt.registerSingleton<ProfileLocalDataSource>(
      ProfileLocalDataSourceImpl(prefs:getIt<SharedPreferences>())
  );
  // --------------------------  R E P O S I T O R Y   -----------------------------------

  getIt.registerSingleton<ProfileRepository>(
      ProfileRepositoryImpl(
        remoteDataSource: getIt<ProfileRemoteDataSource>(),
        localDataSource: getIt<ProfileLocalDataSource>(),
        networkInfo: getIt<NetworkInfo>(),
      )
  );

  // --------------------------  U S E C A S E S   -----------------------------------

  getIt.registerFactory(() => GetUserProfileUseCase(getIt<ProfileRepository>()));
  getIt.registerFactory(() => UpdateUserProfileUseCase(getIt<ProfileRepository>()));
}