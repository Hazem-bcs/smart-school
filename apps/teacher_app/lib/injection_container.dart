// Core and Auth packages
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:core/network/dio_client.dart';
import 'package:core/injection_container.dart' as core_di;
import 'package:auth/injection_container.dart' as auth_di;
import 'package:password/injection_container.dart' as password_di;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teacher_app/core/local_data_source.dart';
import 'package:teacher_app/features/new_assignment/data/data_sources/newAssignmentLocalDataSource.dart';
import 'package:teacher_app/features/new_assignment/domain/usecases/get_classes_use_case.dart';
import 'package:teacher_app/features/profile/presentation/blocs/profile_edit_bloc.dart';
import 'package:teacher_app/features/profile/presentation/blocs/profile_view_bloc.dart';
import 'features/new_assignment/domain/usecases/add_new_assignment_usecase.dart';
import 'features/new_assignment/presentation/blocs/new_assignment_bloc.dart';

// Auth feature imports
import 'features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/data/data_sources/auth_local_data_source.dart';
import 'features/auth/data/data_sources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/presentation/blocs/auth_bloc.dart';

// Home feature imports
import 'features/home/domain/usecases/get_assignments_usecase.dart';
import 'features/home/domain/usecases/get_classes_usecase.dart';
import 'features/home/domain/usecases/get_notifications_usecase.dart';
import 'features/home/data/repositories/home_repository_impl.dart';
import 'features/home/data/data_sources/home_remote_data_source.dart';
import 'features/home/domain/repositories/home_repository.dart';
import 'features/home/presentation/blocs/home_bloc.dart';

// Profile feature imports
import 'features/profile/data/data_sources/profile_remote_data_source.dart';
import 'features/profile/data/repositories/profile_repository_impl.dart';
import 'features/profile/domain/repositories/profile_repository.dart';
import 'features/profile/domain/usecases/get_profile_usecase.dart';
import 'features/profile/domain/usecases/update_profile_usecase.dart';

// Settings feature imports
import 'features/settings/data/datasources/settings_local_data_source.dart';
import 'features/settings/data/datasources/settings_remote_data_source.dart';
import 'features/settings/data/repositories/settings_repository_impl.dart';
import 'features/settings/domain/repositories/settings_repository.dart';
import 'features/settings/domain/usecases/logout_user.dart';
import 'features/settings/presentation/blocs/settings_bloc.dart';

// Assignment feature imports
import 'features/assignment/data/data_sources/remote/assignment_remote_data_source.dart';
import 'features/assignment/data/repositories_impl/assignment_repository_impl.dart';
import 'features/assignment/domain/repositories/assignment_repository.dart';
import 'features/assignment/domain/usecases/get_assignments_usecase.dart'
    as assignment_prefix;
import 'features/assignment/domain/usecases/add_assignment_usecase.dart';
import 'features/assignment/presentation/blocs/assignment_bloc.dart';

// Assignment Submission feature imports
import 'features/assignment_submission/domain/usecases/submit_grade_usecase.dart';
import 'features/assignment_submission/presentation/blocs/submission_bloc.dart';
import 'features/assignment_submission/domain/repositories/submission_repository.dart';
import 'features/assignment_submission/data/data_sources/submission_remote_data_source.dart';
import 'features/assignment_submission/data/repositories/submission_repository_impl.dart';

// Zoom Meeting feature imports
import 'features/zoom_meeting/domain/usecases/schedule_meeting_usecase.dart';
import 'features/zoom_meeting/domain/usecases/get_available_classes_usecase.dart';
import 'features/zoom_meeting/domain/usecases/get_meeting_options_usecase.dart';
import 'features/zoom_meeting/data/repositories/zoom_meeting_repository_impl.dart';
import 'features/zoom_meeting/data/data_sources/zoom_meeting_remote_data_source.dart';
import 'features/zoom_meeting/domain/repositories/zoom_meeting_repository.dart';
import 'features/zoom_meeting/presentation/blocs/zoom_meeting_bloc.dart';

// Core BLoCs imports
import 'package:core/blocs/sensitive_connectivity/connectivity_bloc.dart';
import 'features/new_assignment/data/repositories_impl/new_assignment_repository_impl.dart';
import 'features/new_assignment/domain/repositories/new_assignment_repository.dart';
import 'features/new_assignment/data/data_sources/new_assignment_remote_data_source.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // ========================================
  // CORE DEPENDENCIES SETUP
  // ========================================
  await core_di.setupCoreDependencies(getIt);
  await auth_di.setupAuthDependencies(getIt);
  await password_di.setupPasswordDependencies(getIt);


  getIt.registerLazySingleton<LocalDataSource>(
    () => LocalDataSourceImpl(),
  );
  
  // ========================================
  // AUTH FEATURE DEPENDENCIES
  // ========================================
  // Data Sources
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(),
  );

  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dioClient: getIt<DioClient>()),
  );

  // Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
      localDataSource: getIt<AuthLocalDataSource>(),
      prefs: getIt<SharedPreferences>(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton(() => LoginUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(
    () => CheckAuthStatusUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton(() => LogoutUseCase(getIt<AuthRepository>()));

  // BLoC
  getIt.registerFactory(
    () => AuthBloc(
      checkAuthStatusUseCase: getIt<CheckAuthStatusUseCase>(),
      loginUseCase: getIt<LoginUseCase>(),
      logoutUseCase: getIt<LogoutUseCase>(),
    ),
  );

  // ========================================
  // HOME FEATURE DEPENDENCIES
  // ========================================
  // Data Source
  getIt.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(),
  );

  // Repository
  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(getIt<HomeRemoteDataSource>()),
  );

  // Use Cases
  getIt.registerLazySingleton(
    () => GetHomeClassesUseCase(getIt<HomeRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetNotificationsUseCase(getIt<HomeRepository>()),
  );

  // BLoC
  getIt.registerFactory(
    () => HomeBloc(
      getClassesUseCase: getIt<GetHomeClassesUseCase>(),
      getAssignmentsUseCase: getIt<GetAssignmentsUseCase>(),
      getNotificationsUseCase: getIt<GetNotificationsUseCase>(),
    ),
  );

  // ========================================
  // PROFILE FEATURE DEPENDENCIES
  // ========================================
  // Data Sources


  getIt.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(),
  );

  // Repository
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      remoteDataSource: getIt<ProfileRemoteDataSource>(),
      localDataSource: getIt<LocalDataSource>(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton(
    () => GetProfileUseCase(getIt<ProfileRepository>()),
  );
  getIt.registerLazySingleton(
    () => UpdateProfileUseCase(getIt<ProfileRepository>()),
  );

  // BLoC
  getIt.registerFactory(() => ProfileViewBloc(
    getProfileUseCase: getIt<GetProfileUseCase>(),
  ));

    getIt.registerFactory(() => ProfileEditBloc(
    updateProfileUseCase: getIt<UpdateProfileUseCase>(),
  ));
  
  // ========================================
  // SETTINGS FEATURE DEPENDENCIES
  // ========================================

  // 4. Bloc (يعتمد على Use Case)
  getIt.registerFactory(() => SettingsBloc(logoutUser: getIt<LogoutUser>()));
  getIt.registerLazySingleton<Dio>(() => Dio());

  // 3. Use Case (يعتمد على Repository)
  getIt.registerLazySingleton(() => LogoutUser(getIt<SettingsRepository>()));

  // 2. Repository (يعتمد على Data Sources)
  getIt.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(
      remoteDataSource: getIt<SettingsRemoteDataSource>(),
      localDataSource: getIt<SettingsLocalDataSource>(),
    ),
  );

  //4. data source
  getIt.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(
      sharedPreferences: getIt<SharedPreferences>(),
    ), // تأكد من استيراد SettingsLocalDataSourceImpl
  );

  getIt.registerLazySingleton<SettingsRemoteDataSource>(
    () => SettingsRemoteDataSourceImpl(
      dio: getIt<Dio>(),
      baseUrl: 'YOUR_API_BASE_URL',
    ),
  );

  // ========================================
  // ASSIGNMENT FEATURE DEPENDENCIES
  // ========================================
  // Data Source
  getIt.registerLazySingleton<AssignmentRemoteDataSource>(
    () => AssignmentRemoteDataSourceImpl(),
  );

  // Repository
  getIt.registerLazySingleton<AssignmentRepository>(
    () => AssignmentRepositoryImpl(
      remoteDataSource: getIt<AssignmentRemoteDataSource>(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton(
    () =>
        assignment_prefix.GetAssignmentsUseCase(getIt<AssignmentRepository>()),
  );
  getIt.registerLazySingleton(
    () => AddAssignmentUseCase(getIt<AssignmentRepository>()),
  );
  // BLoC
  getIt.registerFactory(
    () => AssignmentBloc(
      getAssignmentsUseCase: getIt<assignment_prefix.GetAssignmentsUseCase>(),
      addAssignmentUseCase: getIt<AddAssignmentUseCase>(),
    ),
  );

  // ========================================
  // NEW ASSIGNMENT FEATURE DEPENDENCIES
  // ========================================
  // Data Source
  getIt.registerLazySingleton<NewAssignmentRemoteDataSource>(
    () => NewAssignmentRemoteDataSourceImpl(),
  );
  getIt.registerLazySingleton<NewAssignmentLocalDataSource>(
    () => NewAssignmentLocalDataSourceImpl(prefs: getIt<SharedPreferences>()),
  );
  // Repository
  getIt.registerLazySingleton<NewAssignmentRepository>(
    () => NewAssignmentRepositoryImpl(
      getIt<NewAssignmentRemoteDataSource>(),
      getIt<NewAssignmentLocalDataSource>(),
    ),
  );
  // Use Cases
  getIt.registerLazySingleton(
    () => AddNewAssignmentUseCase(getIt<NewAssignmentRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetClassesUseCase(getIt<NewAssignmentRepository>()),
  );

  // BLoC
  getIt.registerFactory(
    () => NewAssignmentBloc(
      addNewAssignmentUseCase: getIt<AddNewAssignmentUseCase>(),
      getClassesUseCase: getIt<GetClassesUseCase>(),
    ),
  );

  // ========================================
  // ASSIGNMENT SUBMISSION FEATURE DEPENDENCIES
  // ========================================
  // Data Source
  getIt.registerLazySingleton<SubmissionRemoteDataSource>(
    () => SubmissionRemoteDataSource(),
  );

  // Repository
  getIt.registerLazySingleton<SubmissionRepository>(
    () => SubmissionRepositoryImpl(
      remoteDataSource: getIt<SubmissionRemoteDataSource>(),
    ),
  );

  // Use Case
  getIt.registerLazySingleton(
    () => SubmitGradeUseCase(getIt<SubmissionRepository>()),
  );

  // BLoC
  getIt.registerFactory(
    () => SubmissionBloc(submitGradeUseCase: getIt<SubmitGradeUseCase>()),
  );

  // ========================================
  // ZOOM MEETING FEATURE DEPENDENCIES
  // ========================================
  // Data Source
  getIt.registerLazySingleton<ZoomMeetingRemoteDataSource>(
    () => ZoomMeetingRemoteDataSourceImpl(),
  );

  // Repository
  getIt.registerLazySingleton<ZoomMeetingRepository>(
    () => ZoomMeetingRepositoryImpl(getIt<ZoomMeetingRemoteDataSource>()),
  );

  // Use Cases
  getIt.registerLazySingleton(
    () => ScheduleMeetingUseCase(getIt<ZoomMeetingRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetAvailableClassesUseCase(getIt<ZoomMeetingRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetMeetingOptionsUseCase(getIt<ZoomMeetingRepository>()),
  );

  // BLoC
  getIt.registerFactory(
    () => ZoomMeetingBloc(
      scheduleMeetingUseCase: getIt<ScheduleMeetingUseCase>(),
      getAvailableClassesUseCase: getIt<GetAvailableClassesUseCase>(),
      getMeetingOptionsUseCase: getIt<GetMeetingOptionsUseCase>(),
    ),
  );

  // ========================================
  // CORE BLOCS
  // ========================================
  getIt.registerFactory(() => ConnectivityBloc(connectivity: Connectivity()));
}
