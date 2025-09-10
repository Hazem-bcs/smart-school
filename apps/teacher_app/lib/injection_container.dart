// Core and Auth packages
import 'package:get_it/get_it.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:core/network/dio_client.dart';
import 'package:core/injection_container.dart' as core_di;
import 'package:auth/injection_container.dart' as auth_di;
import 'package:password/injection_container.dart' as password_di;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teacher_app/core/local_data_source.dart';
import 'package:teacher_app/features/achievements/presentation/blocs/achievements_bloc.dart';
import 'package:teacher_app/features/assignment_submission/domain/usecases/mark_assignment_as_graded_usecase.dart';
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
import 'features/settings/domain/repositories/settings_repository.dart';
import 'features/settings/domain/usecases/logout_usecase.dart' as settings_logout;
import 'features/settings/presentation/blocs/settings_bloc.dart';
import 'features/settings/data/repositories_impl/settings_repository_impl.dart';
import 'features/settings/data/data_sources/remote/settings_remote_data_source.dart';
import 'features/settings/data/data_sources/local/settings_local_data_source.dart';

// Theme BLoC imports
import 'package:core/blocs/theme/theme_bloc.dart';

// Assignment feature imports
import 'features/assignment/data/data_sources/remote/assignment_remote_data_source.dart';
import 'features/assignment/data/repositories_impl/assignment_repository_impl.dart';
import 'features/assignment/domain/repositories/assignment_repository.dart';
import 'features/assignment/domain/usecases/get_assignments_usecase.dart' as assignment_prefix;
import 'features/assignment/presentation/blocs/assignment_bloc.dart';

// Assignment Submission feature imports
import 'features/assignment_submission/domain/usecases/submit_grade_usecase.dart';
import 'features/assignment_submission/presentation/blocs/submission_bloc.dart';
import 'features/assignment_submission/domain/repositories/submission_repository.dart';
import 'features/assignment_submission/data/data_sources/submission_remote_data_source.dart';
import 'features/assignment_submission/data/repositories/submission_repository_impl.dart';
import 'features/assignment_submission/domain/usecases/get_student_submissions_usecase.dart';

// Zoom Meeting feature imports
import 'features/zoom_meeting/domain/usecases/schedule_meeting_usecase.dart';
import 'features/zoom_meeting/domain/usecases/get_available_classes_usecase.dart';
import 'features/zoom_meeting/domain/usecases/get_meeting_options_usecase.dart';
import 'features/zoom_meeting/domain/usecases/get_scheduled_meetings_usecase.dart';
import 'features/zoom_meeting/domain/usecases/get_join_link_usecase.dart';
import 'features/zoom_meeting/data/repositories/zoom_meeting_repository_impl.dart';
import 'features/zoom_meeting/data/data_sources/zoom_meeting_remote_data_source.dart';
import 'features/zoom_meeting/domain/repositories/zoom_meeting_repository.dart';
import 'features/zoom_meeting/presentation/blocs/zoom_meeting_bloc.dart';
import 'features/zoom_meeting/presentation/blocs/meetings_list_bloc.dart';

// Schedule feature imports
import 'features/schedule/domain/usecases/get_schedule_for_date_usecase.dart';
import 'features/schedule/data/repositories/schedule_repository_impl.dart';
import 'features/schedule/data/data_sources/schedule_remote_data_source.dart';
import 'features/schedule/domain/repositories/schedule_repository.dart';
import 'features/schedule/presentation/blocs/schedule_bloc.dart';

// Achievements feature imports
import 'features/achievements/data/data_sources/achievements_remote_data_source.dart';
import 'features/achievements/data/repositories/achievements_repository_impl.dart';
import 'features/achievements/domain/repositories/achievements_repository.dart';
import 'features/achievements/domain/usecases/get_students_usecase.dart';
import 'features/achievements/domain/usecases/get_achievements_usecase.dart';
import 'features/achievements/domain/usecases/grant_achievement_usecase.dart';

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


  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dioClient: getIt<DioClient>()),
  );

  // Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
      localDataSource: getIt<LocalDataSource>(),
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
    () => HomeRemoteDataSourceImpl(dioClient: getIt<DioClient>()),
  );

  // Repository
  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(getIt<HomeRemoteDataSource>(), remoteDataSource: getIt<HomeRemoteDataSource>(), localDataSource: getIt<LocalDataSource>()),
  );

  // Use Cases
  getIt.registerLazySingleton(
    () => GetHomeClassesUseCase(getIt<HomeRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetAssignmentsUseCase(getIt<HomeRepository>()),
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
    () => ProfileRemoteDataSourceImpl(dioClient: getIt<DioClient>()),
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
    getProfileUseCase: getIt<GetProfileUseCase>(),
  ));
  
  // ========================================
  // SETTINGS FEATURE DEPENDENCIES
  // ========================================
  // Data Sources
  getIt.registerLazySingleton<SettingsRemoteDataSource>(
    () => SettingsRemoteDataSourceImpl(dioClient: getIt<DioClient>()),
  );
  getIt.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(
      sharedPreferences: getIt<SharedPreferences>(),
    ),
  );

  // Repository
  getIt.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(
      remoteDataSource: getIt<SettingsRemoteDataSource>(),
      localDataSource: getIt<LocalDataSource>(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton(
    () => settings_logout.LogoutUseCase(getIt<SettingsRepository>()),
  );

  // BLoC
  getIt.registerFactory(
    () => SettingsBloc(
      logoutUseCase: getIt<settings_logout.LogoutUseCase>(),
    ),
  );

  // Theme BLoC
  getIt.registerFactory(() => ThemeBloc());

  // ========================================
  // ASSIGNMENT FEATURE DEPENDENCIES
  // ========================================
  // Data Source
  getIt.registerLazySingleton<AssignmentRemoteDataSource>(
    () => AssignmentRemoteDataSourceImpl(
      dioClient: getIt<DioClient>(),
      localDataSource: getIt<LocalDataSource>(),
    ),
  );

  // Repository
  getIt.registerLazySingleton<AssignmentRepository>(
    () => AssignmentRepositoryImpl(
      remoteDataSource: getIt<AssignmentRemoteDataSource>(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton(
    () => assignment_prefix.GetAssignmentsUseCase(getIt<AssignmentRepository>()),
  );
  
  // BLoC
  getIt.registerFactory(
    () => AssignmentBloc(
      getAssignmentsUseCase: getIt<assignment_prefix.GetAssignmentsUseCase>(),
    ),
  );

  // ========================================
  // NEW ASSIGNMENT FEATURE DEPENDENCIES
  // ========================================
  // Data Source
  getIt.registerLazySingleton<NewAssignmentRemoteDataSource>(
    () => NewAssignmentRemoteDataSourceImpl(
      dioClient: getIt<DioClient>(),
      localDataSource: getIt<LocalDataSource>(),
    ),
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
    () => SubmissionRemoteDataSourceImpl(dioClient: getIt<DioClient>()),
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
  getIt.registerLazySingleton(
    () => GetStudentSubmissionsUseCase(getIt<SubmissionRepository>()),
  );
  getIt.registerLazySingleton(
    () => MarkAssignmentAsGradedUseCase(getIt<SubmissionRepository>()),
  );

  // BLoC
  getIt.registerFactory(
    () => SubmissionBloc(
      submitGradeUseCase: getIt<SubmitGradeUseCase>(),
      getStudentSubmissionsUseCase: getIt<GetStudentSubmissionsUseCase>(),
      markAssignmentAsGradedUseCase: getIt<MarkAssignmentAsGradedUseCase>(),
    ),
  );

  // ========================================
  // ZOOM MEETING FEATURE DEPENDENCIES
  // ========================================
  // Data Source
  getIt.registerLazySingleton<ZoomMeetingRemoteDataSource>(
    () => ZoomMeetingRemoteDataSourceImpl(
      dioClient: getIt<DioClient>(),
      localDataSource: getIt<LocalDataSource>(),
    ),
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
  getIt.registerLazySingleton(
    () => GetScheduledMeetingsUseCase(getIt<ZoomMeetingRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetJoinLinkUseCase(getIt<ZoomMeetingRepository>()),
  );

  // BLoC
  getIt.registerFactory(
    () => ZoomMeetingBloc(
      scheduleMeetingUseCase: getIt<ScheduleMeetingUseCase>(),
      getAvailableClassesUseCase: getIt<GetAvailableClassesUseCase>(),
      getMeetingOptionsUseCase: getIt<GetMeetingOptionsUseCase>(),
    ),
  );
  getIt.registerFactory(
    () => MeetingsListBloc(
      getScheduledMeetingsUseCase: getIt<GetScheduledMeetingsUseCase>(),
      getJoinLinkUseCase: getIt<GetJoinLinkUseCase>(),
    ),
  );

  // ========================================
  // SCHEDULE FEATURE DEPENDENCIES
  // ========================================
  // Data Source
  getIt.registerLazySingleton<ScheduleRemoteDataSource>(
    () => ScheduleRemoteDataSourceImpl(dioClient: getIt<DioClient>()),
  );

  // Repository
  getIt.registerLazySingleton<ScheduleRepository>(
    () => ScheduleRepositoryImpl(getIt<ScheduleRemoteDataSource>(), getIt<LocalDataSource>()),
  );

  // Use Cases
  getIt.registerLazySingleton(
    () => GetScheduleForDateUseCase(getIt<ScheduleRepository>()),
  );

  // BLoC
  getIt.registerFactory(
    () => ScheduleBloc(
      getScheduleForDateUseCase: getIt<GetScheduleForDateUseCase>(),
    ),
  );

  // ========================================
  // ACHIEVEMENTS FEATURE DEPENDENCIES
  // ========================================
  // Data Source
  getIt.registerLazySingleton<AchievementsRemoteDataSource>(
    () => AchievementsRemoteDataSourceImpl(dioClient: getIt<DioClient>()),
  );

  // Repository
  getIt.registerLazySingleton<AchievementsRepository>(
    () => AchievementsRepositoryImpl(
      remoteDataSource: getIt<AchievementsRemoteDataSource>(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton(
    () => GetStudentsUseCase(getIt<AchievementsRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetAvailableAchievementsUseCase(getIt<AchievementsRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetStudentAchievementsUseCase(getIt<AchievementsRepository>()),
  );
  getIt.registerLazySingleton(
    () => GrantAchievementUseCase(getIt<AchievementsRepository>()),
  );
  getIt.registerLazySingleton(
    () => RevokeAchievementUseCase(getIt<AchievementsRepository>()),
  );

  // BLoC
  getIt.registerFactory(
    () => AchievementsBloc(
      getStudentsUseCase: getIt<GetStudentsUseCase>(),
      getAvailableAchievementsUseCase: getIt<GetAvailableAchievementsUseCase>(),
      getStudentAchievementsUseCase: getIt<GetStudentAchievementsUseCase>(),
      grantAchievementUseCase: getIt<GrantAchievementUseCase>(),
      revokeAchievementUseCase: getIt<RevokeAchievementUseCase>(),
    ),
  );

  // ========================================
  // CORE BLOCS
  // ========================================
  getIt.registerFactory(() => ConnectivityBloc(connectivity: Connectivity()));
}
