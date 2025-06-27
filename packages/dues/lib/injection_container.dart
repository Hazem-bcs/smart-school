
import 'package:core/network/dio_client.dart';
import 'package:core/network/network_info.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/datasources/dues_local_data_source.dart';
import 'data/datasources/dues_remote_datasource.dart';
import 'data/dues_repository_impl.dart';
import 'domain/dues_repository.dart';
import 'domain/usecases/get_my_dues.dart';


Future<void> setupDuesDependencies(GetIt getIt) async {

  // --------------------------  D A T A S O U R C E S   -----------------------------------

  getIt.registerSingleton<DuesRemoteDataSource>(
      DuesRemoteDataSourceImpl(dioClient: getIt<DioClient>())
  );

  // --------------------------  S  H  A  R  E  D  P  R  E  F   -----------------------------------

  getIt.registerSingleton<DuesLocalDataSource>(
      DuesLocalDataSourceImpl(prefs:getIt<SharedPreferences>())
  );

  // --------------------------  R E P O S I T O R Y   -----------------------------------

  getIt.registerSingleton<DuesRepository>(
      DuesRepositoryImpl(
        remoteDataSource: getIt<DuesRemoteDataSource>(),
        localDataSource: getIt<DuesLocalDataSource>(),
        networkInfo: getIt<NetworkInfo>(),
      )
  );

  // --------------------------  U S E C A S E S   -----------------------------------

  getIt.registerFactory(() => GetMyDuesUseCase(getIt<DuesRepository>()));
}