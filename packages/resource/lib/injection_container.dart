
import 'package:core/network/dio_client.dart';
import 'package:core/network/network_info.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/data_sources/resoruce_local_data_source.dart';
import 'data/data_sources/resoruce_remote_data_source.dart';
import 'data/resource_repository_impl.dart';
import 'domain/resource_repositroty.dart';
import 'domain/use_cases/get_resource_list_use_case.dart';


Future<void> setupResourceDependencies(GetIt getIt) async {

  // --------------------------  D A T A S O U R C E S   -----------------------------------

  getIt.registerSingleton<ResourceRemoteDataSource>(
      ResourceRemoteDataSourceImpl(dioClient: getIt<DioClient>())
  );

  // --------------------------  S  H  A  R  E  D  P  R  E  F   -----------------------------------

  getIt.registerSingleton<ResourceLocalDataSource>(
      ResourceLocalDataSourceImpl(prefs:getIt<SharedPreferences>())
  );
  // --------------------------  R E P O S I T O R Y   -----------------------------------

  getIt.registerSingleton<ResourceRepository>(
      ResourceRepositoryImpl(
        remoteDataSource: getIt<ResourceRemoteDataSource>(),
        localDataSource: getIt<ResourceLocalDataSource>(),
        networkInfo: getIt<NetworkInfo>(),
      )
  );

  // --------------------------  U S E C A S E S   -----------------------------------

  getIt.registerFactory(() => GetResourceListUseCase(getIt<ResourceRepository>()));
}