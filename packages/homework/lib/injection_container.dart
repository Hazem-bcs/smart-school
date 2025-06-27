
import 'package:core/network/dio_client.dart';
import 'package:core/network/network_info.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/data_sources/home_work_local_data_source.dart';
import 'data/data_sources/homework_remote_data_source.dart';
import 'data/homework_repository_impl.dart';
import 'domain/homework_repository.dart';
import 'domain/usecases/get_homework_use_case.dart';
import 'domain/usecases/get_question_list_use_case.dart';
import 'domain/usecases/submit_homework_usecase.dart';


Future<void> setupHomeWorkDependencies(GetIt getIt) async {

  // --------------------------  D A T A S O U R C E S   -----------------------------------

  getIt.registerSingleton<HomeworkRemoteDataSource>(
      HomeworkRemoteDataSourceImpl(dioClient: getIt<DioClient>())
  );

  // --------------------------  S  H  A  R  E  D  P  R  E  F   -----------------------------------

  getIt.registerSingleton<HomeWorkLocalDataSource>(
      HomeWorkLocalDataSourceImpl(prefs:getIt<SharedPreferences>())
  );


  // --------------------------  R E P O S I T O R Y   -----------------------------------

  getIt.registerSingleton<HomeworkRepository>(
      HomeworkRepositoryImpl(
        remoteDataSource: getIt<HomeworkRemoteDataSource>(),
        homeWorkLocalDataSource: getIt<HomeWorkLocalDataSource>(),
        networkInfo: getIt<NetworkInfo>(),
      )
  );

  // --------------------------  U S E C A S E S   -----------------------------------

  getIt.registerFactory(() => GetHomeworkUseCase(getIt<HomeworkRepository>()));
  getIt.registerFactory(() => SubmitHomeworkUseCase(getIt<HomeworkRepository>()));
  getIt.registerFactory(() => GetQuestionListUseCase(getIt<HomeworkRepository>()));
}