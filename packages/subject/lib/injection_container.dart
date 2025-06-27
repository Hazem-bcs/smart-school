
import 'package:core/network/dio_client.dart';
import 'package:core/network/network_info.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/data_sources/subject_local_data_source.dart';
import 'data/data_sources/subject_remote_data_source.dart';
import 'data/subject_repositery_impl.dart';
import 'domain/Subject_repository.dart';
import 'domain/use_cases/get_subject_list_use_case.dart';
import 'domain/use_cases/get_subject_use_case.dart';

Future<void> setupSubjectDependencies(GetIt getIt) async {

  // --------------------------  D A T A S O U R C E S   -----------------------------------

  getIt.registerSingleton<SubjectRemoteDataSource>(
      SubjectRemoteDataSourceImpl(dioClient: getIt<DioClient>())
  );

  // --------------------------  S  H  A  R  E  D  P  R  E  F   -----------------------------------

  getIt.registerSingleton<SubjectLocalDataSource>(
      SubjectLocalDataSourceImpl(prefs:getIt<SharedPreferences>())
  );;
  // --------------------------  R E P O S I T O R Y   -----------------------------------

  getIt.registerSingleton<SubjectRepository>(
      SubjectRepositoryImpl(
        remoteDataSource: getIt<SubjectRemoteDataSource>(),
        localDataSource: getIt<SubjectLocalDataSource>(),
        networkInfo: getIt<NetworkInfo>(),
      )
  );

  // --------------------------  U S E C A S E S   -----------------------------------

  getIt.registerFactory(() => GetSubjectUseCase(getIt<SubjectRepository>()));
  getIt.registerFactory(() => GetSubjectLListUseCase(getIt<SubjectRepository>()));

}