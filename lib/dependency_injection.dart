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
import 'features/dues/domain/dues_repository.dart';
import 'features/authentication/domain/usecases/cheakauthstatus_usecase.dart';
import 'features/authentication/domain/usecases/login_usecase.dart';
import 'features/authentication/presentation/blocs/auth_bloc.dart';
import 'features/dues/data/datasources/dues_local_data_source.dart';
import 'features/dues/data/datasources/dues_remote_datasource.dart';
import 'features/dues/data/dues_repository_impl.dart';
import 'features/dues/domain/usecases/get_my_dues.dart';
import 'features/dues/presentation/blocs/dues_bloc.dart';
import 'features/homework/presentation/blocs/homework_bloc.dart';
import 'features/profile/data/data_sources/profile_local_data_source.dart';
import 'features/profile/data/data_sources/profile_remote_data_source.dart';
import 'features/profile/data/profile_repository_impl.dart';
import 'features/profile/domain/use_cases/get_user_profile_use_case.dart';
import 'features/profile/domain/profile_repository.dart';
import 'features/profile/presentation/bolcs/profile_bloc.dart';
import 'features/subject/data/data_sources/subject_local_data_source.dart';
import 'features/subject/data/data_sources/subject_remote_data_source.dart';
import 'features/subject/data/subject_repositery_impl.dart';
import 'features/subject/domain/Subject_repository.dart';
import 'features/subject/domain/get_subject_use_case.dart';
import 'features/subject/presentation/blocs/subject_bloc.dart';
import 'features/teacher/data/data_sources/teacher_local_data_source.dart';
import 'features/teacher/data/data_sources/teacher_remote_data_source.dart';
import 'features/teacher/data/teacher_repository_impl.dart';
import 'features/teacher/domain/teatcher_repository.dart';
import 'features/teacher/domain/use_cases/get_teacher_by_id_use_case.dart';
import 'features/teacher/domain/use_cases/get_teacher_list_use_case.dart';
import 'features/teacher/presentation/blocs/teacher_bloc.dart';

final   getIt = GetIt.instance;

Future<void> setupDependencies() async {
  getIt.registerSingleton<DioClient>(DioClient(dio: Dio()));
  getIt.registerSingleton<NetworkInfo>(NetworkInfoImpl(Connectivity()));

// --------------------------  R  E  M  O  T  E  D  A  T  A   -----------------------------------

  getIt.registerSingleton<AuthRemoteDataSource>(
      AuthRemoteDataSourceImpl(dioClient: getIt<DioClient>())
  );
  getIt.registerSingleton<HomeworkRemoteDataSource>(
      HomeworkRemoteDataSourceImpl(dioClient: getIt<DioClient>())
  );
  getIt.registerSingleton<DuesRemoteDataSource>(
      DuesRemoteDataSourceImpl(dioClient: getIt<DioClient>())
  );
  getIt.registerSingleton<ProfileRemoteDataSource>(
      ProfileRemoteDataSourceImpl(dioClient: getIt<DioClient>())
  );
  getIt.registerSingleton<SubjectRemoteDataSource>(
      SubjectRemoteDataSourceImpl(dioClient: getIt<DioClient>())
  );
  getIt.registerSingleton<TeacherRemoteDataSource>(
      TeacherRemoteDataSourceImpl(dioClient: getIt<DioClient>())
  );

// --------------------------  S  H  A  R  E  D  P  R  E  F   -----------------------------------

  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);

  getIt.registerSingleton<AuthLocalDataSource>(
      AuthLocalDataSourceImpl(prefs:getIt<SharedPreferences>())
  );
  getIt.registerSingleton<HomeWorkLocalDataSource>(
    HomeWorkLocalDataSourceImpl(prefs:getIt<SharedPreferences>())
  );
  getIt.registerSingleton<DuesLocalDataSource>(
      DuesLocalDataSourceImpl(prefs:getIt<SharedPreferences>())
  );
  getIt.registerSingleton<SubjectLocalDataSource>(
      SubjectLocalDataSourceImpl(prefs:getIt<SharedPreferences>())
  );
  getIt.registerSingleton<ProfileLocalDataSource>(
      ProfileLocalDataSourceImpl(prefs:getIt<SharedPreferences>())
  );
  getIt.registerSingleton<TeacherLocalDataSource>(
      TeacherLocalDataSourceImpl(prefs:getIt<SharedPreferences>())
  );

// --------------------------  A  U  T  H  R  E  P  O   -----------------------------------

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
  getIt.registerSingleton<DuesRepository>(
      DuesRepositoryImpl(
        remoteDataSource: getIt<DuesRemoteDataSource>(),
        localDataSource: getIt<DuesLocalDataSource>(),
        networkInfo: getIt<NetworkInfo>(),
      )
  );
  getIt.registerSingleton<SubjectRepository>(
      SubjectRepositoryImpl(
        remoteDataSource: getIt<SubjectRemoteDataSource>(),
        networkInfo: getIt<NetworkInfo>(),
      )
  );
  getIt.registerSingleton<ProfileRepository>(
      ProfileRepositoryImpl(
        remoteDataSource: getIt<ProfileRemoteDataSource>(),
        localDataSource: getIt<ProfileLocalDataSource>(),
        networkInfo: getIt<NetworkInfo>(),
      )
  );
  getIt.registerSingleton<TeacherRepository>(
      TeacherRepositoryImpl(
        remoteDataSource: getIt<TeacherRemoteDataSource>(),
        localDataSource: getIt<TeacherLocalDataSource>(),
        networkInfo: getIt<NetworkInfo>(),
      )
  );
// --------------------------  U  S  E  C  A  S  E   -----------------------------------
  
  getIt.registerFactory(() => LoginUseCase(getIt<AuthRepository>()));
  getIt.registerFactory(() => CheckAuthStatusUseCase(getIt<AuthRepository>()));
  getIt.registerFactory(() => GetHomeworkUseCase(getIt<HomeworkRepository>()));
  getIt.registerFactory(() => GetMyDuesUseCase(getIt<DuesRepository>()));
  getIt.registerFactory(() => GetUserProfileUseCase(getIt<ProfileRepository>()));
  getIt.registerFactory(() => GetSubjectUseCase(getIt<SubjectRepository>()));
  getIt.registerFactory(() => GetTeacherByIdUseCase(getIt<TeacherRepository>()));
  getIt.registerFactory(() => GetTeacherListUseCase(getIt<TeacherRepository>()));

// --------------------------  B  L  O  C   ----------------------------------- 
  
  getIt.registerFactory(() => AuthBloc(checkAuthStatusUseCase:getIt<CheckAuthStatusUseCase>(), loginUseCase: getIt<LoginUseCase>()));
  getIt.registerFactory(() => HomeworkBloc(getHomework: getIt<GetHomeworkUseCase>()));
  getIt.registerFactory(() => DuesBloc(getMyDuesUseCase: getIt<GetMyDuesUseCase>()));
  getIt.registerFactory(() => ProfileBloc(getUserProfileUseCase: getIt<GetUserProfileUseCase>()));
  getIt.registerFactory(() => SubjectBloc(getSubjectUseCase: getIt<GetSubjectUseCase>()));
  getIt.registerFactory(() => TeacherBloc(teacherByIdUseCase: getIt<GetTeacherByIdUseCase>(), teacherListUseCase: getIt<GetTeacherListUseCase>()));
}