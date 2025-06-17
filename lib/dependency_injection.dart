import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_school/core/network/network_info.dart';
import 'package:smart_school/features/homework/data/data_sources/home_work_local_data_source.dart';
import 'package:smart_school/features/homework/data/data_sources/homework_remote_data_source.dart';
import 'package:smart_school/features/homework/data/homework_repository_impl.dart';
import 'package:smart_school/features/homework/domain/homework_repository.dart';
import 'package:smart_school/features/homework/domain/usecases/get_homework_use_case.dart';

import 'core/network/dio_client.dart';
import 'features/authentication/data/auth_repository_impl.dart';
import 'features/authentication/data/data_sources/auth_local_data_source.dart';
import 'features/authentication/data/data_sources/auth_remote_data_source.dart';
import 'features/authentication/domain/auth_repository.dart';
import 'features/authentication/domain/usecases/cheakauthstatus_usecase.dart';
import 'features/authentication/domain/usecases/login_usecase.dart';
import 'features/authentication/presentation/blocs/auth_bloc.dart';
import 'features/homework/presentation/blocs/homework_bloc.dart';

final   getIt = GetIt.instance;

Future<void> setupDependencies() async {
  getIt.registerSingleton<DioClient>(DioClient(dio: Dio()));
  getIt.registerSingleton<NetworkInfo>(NetworkInfoImpl(Connectivity()));
  getIt.registerSingleton<AuthRemoteDataSource>(
      AuthRemoteDataSourceImpl(dioClient: getIt<DioClient>())
  );
  getIt.registerSingleton<HomeworkRemoteDataSource>(
      HomeworkRemoteDataSourceImpl(dioClient: getIt<DioClient>())
  );

  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);

  getIt.registerSingleton<AuthLocalDataSource>(
      AuthLocalDataSourceImpl(prefs:getIt<SharedPreferences>())
  );
  getIt.registerSingleton<HomeWorkLocalDataSource>(
    HomeWorkLocalDataSourceImpl(prefs:getIt<SharedPreferences>())
  );

  getIt.registerSingleton<AuthRepository>(
      AuthRepositoryImpl(
        remoteDataSource: getIt<AuthRemoteDataSource>(),
        localDataSource: getIt<AuthLocalDataSource>(),
        networkInfo: getIt<NetworkInfo>(),
      )
  );
  getIt.registerSingleton<HomeworkRepository>(
    HomeworkRepositoryImpl(
      remoteDataSource: getIt<HomeworkRemoteDataSource>(),
      homeWorkLocalDataSource: getIt<HomeWorkLocalDataSource>(),
      networkInfo: getIt<NetworkInfo>(),
    )
  );

  getIt.registerFactory(() => LoginUseCase(getIt<AuthRepository>()));
  getIt.registerFactory(() => CheckAuthStatusUseCase(getIt<AuthRepository>()));
  getIt.registerFactory(() => GetHomeworkUseCase(getIt<HomeworkRepository>()));
  getIt.registerFactory(() => AuthBloc(checkAuthStatusUseCase:getIt<CheckAuthStatusUseCase>(), loginUseCase: getIt<LoginUseCase>()));
  getIt.registerFactory(() => HomeworkBloc(getHomework: getIt<GetHomeworkUseCase>()));

}