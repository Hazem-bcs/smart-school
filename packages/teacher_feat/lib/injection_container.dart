

import 'package:core/network/dio_client.dart';
import 'package:core/network/network_info.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/data_sources/teacher_local_data_source.dart';
import 'data/data_sources/teacher_remote_data_source.dart';
import 'data/teacher_repository_impl.dart';
import 'domain/teatcher_repository.dart';
import 'domain/use_cases/get_teacher_by_id_use_case.dart';
import 'domain/use_cases/get_teacher_list_use_case.dart';

Future<void> setupTeacherFeatDependencies(GetIt getIt) async {

  // --------------------------  D A T A S O U R C E S   -----------------------------------

  getIt.registerSingleton<TeacherRemoteDataSource>(
      TeacherRemoteDataSourceImpl(dioClient: getIt<DioClient>())
  );

  // --------------------------  S  H  A  R  E  D  P  R  E  F   -----------------------------------

  getIt.registerSingleton<TeacherLocalDataSource>(
      TeacherLocalDataSourceImpl(prefs:getIt< SharedPreferences>())
  );
  // --------------------------  R E P O S I T O R Y   -----------------------------------

  getIt.registerSingleton<TeacherRepository>(
      TeacherRepositoryImpl(
        remoteDataSource: getIt<TeacherRemoteDataSource>(),
        localDataSource: getIt<TeacherLocalDataSource>(),
        networkInfo: getIt<NetworkInfo>(),
      )
  );
  // --------------------------  U S E C A S E S   -----------------------------------

  getIt.registerFactory(() => GetTeacherByIdUseCase(getIt<TeacherRepository>()));
  getIt.registerFactory(() => GetTeacherListUseCase(getIt<TeacherRepository>()));

}