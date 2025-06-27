
import 'package:core/network/dio_client.dart';
import 'package:core/network/network_info.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/data_sources/notification_local_data_source.dart';
import 'data/data_sources/notification_remote_data_source.dart';
import 'data/notification_repository_impl.dart';
import 'domain/notification_repositoty.dart';
import 'domain/use_cases/get_notification_list_use_case.dart';


Future<void> setupNotificationDependencies(GetIt getIt) async {

  // --------------------------  D A T A S O U R C E S   -----------------------------------

  getIt.registerSingleton<NotificationRemoteDataSource>(
      NotificationRemoteDataSourceImpl(dioClient: getIt<DioClient>())
  );

  // --------------------------  S  H  A  R  E  D  P  R  E  F   -----------------------------------

  getIt.registerSingleton<NotificationLocalDataSource>(
      NotificationLocalDataSourceImpl(prefs:getIt<SharedPreferences>())
  );

  // --------------------------  R E P O S I T O R Y   -----------------------------------

  getIt.registerSingleton<NotificationRepository>(
      NotificationRepositoryImpl(
        remoteDataSource: getIt<NotificationRemoteDataSource>(),
        localDataSource: getIt<NotificationLocalDataSource>(),
        networkInfo: getIt<NetworkInfo>(),
      )
  );

  // --------------------------  U S E C A S E S   -----------------------------------

  getIt.registerFactory(() => GetNotificationListUseCase(getIt<NotificationRepository>()));

}