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
import 'features/authentication/domain/dues_repository.dart';
import 'features/authentication/domain/usecases/cheakauthstatus_usecase.dart';
import 'features/authentication/domain/usecases/login_usecase.dart';
import 'features/authentication/presentation/blocs/auth_bloc.dart';
import 'features/dues/data/datasources/dues_local_data_source.dart';
import 'features/dues/data/datasources/dues_remote_datasource.dart';
import 'features/dues/data/dues_repository_impl.dart';
import 'features/dues/domain/usecases/get_my_dues.dart';
import 'features/dues/presentation/blocs/dues_bloc.dart';
import 'features/homework/presentation/blocs/homework_bloc.dart';
final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // Core services
  getIt.registerSingleton<DioClient>(DioClient(dio: Dio()));
  getIt.registerSingleton<NetworkInfo>(NetworkInfoImpl(Connectivity()));

  // Shared Preferences (only initialize once if needed by multiple sources)
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);

  // --- Remote Data Sources ---
  getIt.registerSingleton<AuthRemoteDataSource>(
      AuthRemoteDataSourceImpl(dioClient: getIt<DioClient>())
  );
  getIt.registerSingleton<HomeworkRemoteDataSource>(
      HomeworkRemoteDataSourceImpl(dioClient: getIt<DioClient>())
  );
  // *** تسجيل DuesRemoteDataSourceImpl ***
  getIt.registerSingleton<DuesRemoteDataSource>( // قم بتسجيل الواجهة
      DuesRemoteDataSourceImpl(dioClient: getIt<DioClient>())
  );

  // --- Local Data Sources ---
  getIt.registerSingleton<AuthLocalDataSource>(
      AuthLocalDataSourceImpl(prefs:getIt<SharedPreferences>())
  );
  getIt.registerSingleton<HomeWorkLocalDataSource>(
      HomeWorkLocalDataSourceImpl(prefs:getIt<SharedPreferences>())
  );
  getIt.registerSingleton<DuesLocalDataSource>(
      DuesLocalDataSourceImpl(prefs: getIt<SharedPreferences>())
  );


  // --- Repositories ---
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
  // *** تسجيل DuesRepositoryImpl ***
  getIt.registerSingleton<DuesRepository>( // قم بتسجيل الواجهة
      DuesRepositoryImpl(
        networkInfo: getIt<NetworkInfo>(),
        duesRemoteDataSource: getIt<DuesRemoteDataSource>(),
        duesLocalDataSource: getIt<DuesLocalDataSource>(),
      )
  );


  // --- Use Cases (Factory) ---
  getIt.registerFactory(() => LoginUseCase(getIt<AuthRepository>()));
  getIt.registerFactory(() => CheckAuthStatusUseCase(getIt<AuthRepository>()));
  getIt.registerFactory(() => GetHomeworkUseCase(getIt<HomeworkRepository>()));
  // *** تسجيل GetMyDuesUseCase ***
  getIt.registerFactory(() => GetMyDuesUseCase(getIt<DuesRepository>()));


  // --- Blocs (Factory) ---
  getIt.registerFactory(() => AuthBloc(checkAuthStatusUseCase:getIt<CheckAuthStatusUseCase>(), loginUseCase: getIt<LoginUseCase>()));
  getIt.registerFactory(() => HomeworkBloc(getHomework: getIt<GetHomeworkUseCase>()));
  // *** تسجيل DuesBloc ***
  getIt.registerFactory(() => DuesBloc(getMyDuesUseCase: getIt<GetMyDuesUseCase>()));

}