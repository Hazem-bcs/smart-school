
import 'package:core/blocs/theme/theme_bloc.dart';
import 'package:core/network/dio_client.dart';
import 'package:core/network/network_info.dart';
import 'package:get_it/get_it.dart';

// Core & Shared Packages
import 'package:dio/dio.dart';

// Core Feature Dependency Injection
import 'package:core/injection_container.dart' as core_di;

// Auth Feature
import 'package:auth/domain/usecases/cheakauthstatus_usecase.dart';
import 'package:auth/domain/usecases/login_usecase.dart';
import 'package:auth/domain/usecases/logout_usecase.dart';
import 'package:auth/injection_container.dart' as auth_di;

// Dues Feature
import 'package:dues/domain/usecases/get_my_dues.dart';
import 'package:dues/injection_container.dart' as dues_di;

// Homework Feature
import 'package:homework/domain/usecases/get_homework_use_case.dart';
import 'package:homework/domain/usecases/get_question_list_use_case.dart';
import 'package:homework/domain/usecases/submit_homework_usecase.dart';
import 'package:homework/injection_container.dart' as homework_di;

// Notification Feature
import 'package:notification/domain/use_cases/get_notification_list_use_case.dart';
import 'package:notification/injection_container.dart' as notification_di;

// Profile Feature
import 'package:profile/domain/use_cases/get_user_profile_use_case.dart';
import 'package:profile/injection_container.dart' as profile_di;

// Resource Feature
import 'package:resource/domain/use_cases/get_resource_list_use_case.dart';
import 'package:resource/injection_container.dart' as resource_di;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_school/features/ai_tutor/presentation/bloc/tutor_chat_bloc.dart';
import 'package:smart_school/features/notification/presintation/bloc/notification_bloc.dart';
import 'package:smart_school/features/schedule/data/data_sources/schedule_local_data_source.dart';
import 'package:smart_school/features/schedule/data/data_sources/schedule_remote_data_source.dart';
import 'package:smart_school/features/schedule/data/repositories/schedule_repository_impl.dart';
import 'package:smart_school/features/schedule/domain/repositories/schedule_repository.dart';
import 'package:smart_school/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:smart_school/features/settings/data/datasources/settings_remote_data_source.dart';
import 'package:smart_school/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:smart_school/features/settings/domain/repositories/settings_repository.dart';
import 'package:smart_school/features/settings/domain/usecases/get_profile.dart';
import 'package:smart_school/features/settings/presentation/blocs/settings_bloc.dart';

// Subject Feature
import 'package:subject/domain/use_cases/get_subject_list_use_case.dart';
import 'package:subject/domain/use_cases/get_subject_use_case.dart';
import 'package:subject/injection_container.dart' as subject_di;

// Teacher Feature
import 'package:teacher_feat/domain/use_cases/get_teacher_by_id_use_case.dart';
import 'package:teacher_feat/domain/use_cases/get_teacher_list_use_case.dart';
import 'package:teacher_feat/injection_container.dart' as teacher_di;

// Attendance Feature
import 'package:attendance/injection_container.dart' as attendance_di;

// Schedule Feature
import 'package:smart_school/features/schedule/domain/usecases/get_schedule_for_date_usecase.dart';
import 'package:smart_school/features/schedule/presentation/blocs/schedule_bloc.dart';

// Zoom Feature
import 'package:smart_school/features/zoom/domain/usecase/get_all_zoom_meetings_useCase.dart';
import 'package:smart_school/features/zoom/presentation/bloc/zoom_meetings_bloc.dart';

import 'features/zoom/data/datasources/zoom_meetings_remote_data_source.dart';
import 'features/zoom/data/repositories/zoom_meetings_repository_impl.dart';

// AI Tutor Feature
import 'features/ai_tutor/data/datasources/ai_tutor_remote_datasource.dart';
import 'features/ai_tutor/data/repositories/ai_tutor_repository_impl.dart';
import 'features/ai_tutor/domain/repositories/repositories.dart';
import 'features/ai_tutor/domain/use_cases/send_chat_message_use_case.dart';

// Home Feature
import 'features/home/injection_container.dart' as home_di;

// Presentation Layer - BLoCs
import 'features/authentication/presentation/blocs/auth_bloc.dart';
import 'features/dues/presentation/blocs/dues_bloc.dart';
import 'features/quiz/presentation/blocs/home_work_bloc/homework_bloc.dart';
import 'features/quiz/presentation/blocs/question_bloc/question_bloc.dart';
import 'features/profile/presentation/bolcs/profile_bloc.dart';
import 'features/resource/presintation/blocs/resource_bloc.dart';
import 'features/subject/presentation/blocs/subject/subject_bloc.dart';
import 'features/subject/presentation/blocs/subject_list/subject_list_bloc.dart';
import 'features/teacher/presentation/blocs/teacher_list_bloc.dart';
import 'features/teacher/presentation/blocs/teacher_details_bloc.dart';

// GetIt instance
final getIt = GetIt.instance;

/// Sets up all dependencies for the Student App.
/// This includes core, feature, data, domain, and presentation layer dependencies.
Future<void> setupDependencies() async {
  // Register Dio (should be replaced with DioClient in future refactor)
  getIt.registerLazySingleton<Dio>(() => Dio());

  // ---------------- Core & Feature Dependency Injection ----------------
  // Call setup for each feature's dependencies in the correct order
  await core_di.setupCoreDependencies(getIt);
  await auth_di.setupAuthDependencies(getIt);
  await dues_di.setupDuesDependencies(getIt);
  await homework_di.setupHomeWorkDependencies(getIt);
  await notification_di.setupNotificationDependencies(getIt);
  await profile_di.setupProfileDependencies(getIt);
  await resource_di.setupResourceDependencies(getIt);
  await subject_di.setupSubjectDependencies(getIt);
  await teacher_di.setupTeacherFeatDependencies(getIt);
  await attendance_di.setupAttendanceDependencies(getIt);

  // ---------------- AI Tutor Feature ----------------
  // Data Source
  getIt.registerLazySingleton<AITutorRemoteDataSource>(
    () => AITutorRemoteDataSourceImpl(),
  );
  getIt.registerLazySingleton<ScheduleRemoteDataSource>(
    () => ScheduleRemoteDataSourceImpl(dioClient: getIt<DioClient>()),
  );
  getIt.registerLazySingleton<SettingsRemoteDataSource>(
    () => SettingsRemoteDataSourceImpl(dioClient: getIt<DioClient>()),
  );
  getIt.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(prefs: getIt<SharedPreferences>()),
  );
  getIt.registerLazySingleton<ScheduleLocalDataSource>(
    () => ScheduleLocalDataSourceImpl(prefs: getIt<SharedPreferences>()),
  );

  // Repository
  getIt.registerLazySingleton<AITutorRepository>(
    () => AITutorRepositoryImpl(
      remoteDataSource: getIt<AITutorRemoteDataSource>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );
  getIt.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(
      remoteDataSource: getIt<SettingsRemoteDataSource>(),
      localDataSource: getIt<SettingsLocalDataSource>(),
    ),
  );

  getIt.registerLazySingleton<ScheduleRepository>(
    () => ScheduleRepositoryImpl(
      localDataSource: getIt<ScheduleLocalDataSource>(),
      remoteDataSource: getIt<ScheduleRemoteDataSource>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );
  // Use Case
  getIt.registerLazySingleton<SendChatMessageUseCase>(
    () => SendChatMessageUseCase(getIt<AITutorRepository>()),
  );
  getIt.registerLazySingleton<GetScheduleForDateUseCase>(
    () => GetScheduleForDateUseCase(getIt<ScheduleRepository>()),
  );
  getIt.registerLazySingleton<GetProfileUseCase>(
    () => GetProfileUseCase(getIt<SettingsRepository>()),
  );

  // ---------------- Authentication Feature ----------------
  getIt.registerFactory(
    () => AuthBloc(
      checkAuthStatusUseCase: getIt<CheckAuthStatusUseCase>(),
      loginUseCase: getIt<LoginUseCase>(),
      logoutUseCase: getIt<LogoutUseCase>(),
    ),
  );

  // ---------------- Schedule Feature ----------------
  getIt.registerFactory(
    () => ScheduleBloc(
      getScheduleForDateUseCase: getIt<GetScheduleForDateUseCase>(),
    ),
  );

  // ---------------- Homework Feature ----------------
  getIt.registerFactory(
    () => HomeworkBloc(getHomework: getIt<GetHomeworkUseCase>()),
  );
  getIt.registerFactory(
    () => QuestionBloc(
      getQuestionListUseCase: getIt<GetQuestionListUseCase>(),
      submitHomeworkUseCase: getIt<SubmitHomeworkUseCase>(),
    ),
  );

  // ---------------- Dues Feature ----------------
  getIt.registerFactory(
    () => DuesBloc(getMyDuesUseCase: getIt<GetMyDuesUseCase>()),
  );

  // ---------------- Profile Feature ----------------
  getIt.registerFactory(
    () => ProfileBloc(
      getUserProfileUseCase: getIt<GetUserProfileUseCase>(),
      updateUserProfileUseCase: getIt<UpdateUserProfileUseCase>(),
    ),
  );

  // ---------------- Subject Feature ----------------
  getIt.registerFactory(
    () => SubjectBloc(getSubjectUseCase: getIt<GetSubjectUseCase>()),
  );
  getIt.registerFactory(
    () => SubjectListBloc(
      getSubjectLListUseCase: getIt<GetSubjectLListUseCase>(),
    ),
  );



  // ---------------- Resource Feature ----------------
  getIt.registerFactory(
    () => ResourceBloc(getResourceListUseCase: getIt<GetResourceListUseCase>()),
  );

  // ---------------- Teacher Feature ----------------
  getIt.registerFactory(
    () => TeacherListBloc(teacherListUseCase: getIt<GetTeacherListUseCase>()),
  );
  getIt.registerFactory(
    () => TeacherDetailsBloc(teacherByIdUseCase: getIt<GetTeacherByIdUseCase>()),
  );

  // ---------------- Zoom Feature ----------------

  // Data Sources
  getIt.registerLazySingleton<ZoomMeetingsRemoteDataSource>(
    () => ZoomMeetingsRemoteDataSourceImpl(dio: getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<ZoomMeetingsRepositoryImpl>(
    () => ZoomMeetingsRepositoryImpl(remoteDataSource: getIt()),
  );

  // Use Cases
  getIt.registerLazySingleton(
    () => GetAllZoomMeetingsUseCase(
      repository: getIt<ZoomMeetingsRepositoryImpl>(),
    ),
  );

  // BLoCs
  getIt.registerFactory(
    () => ZoomMeetingsBloc(
      getAllZoomMeetingsUseCase:
          getIt(),
    ),
  );

  // ---------------- Settings Feature ----------------
  getIt.registerFactory(
    () => SettingsBloc(getProfile: getIt<GetProfileUseCase>()),
  );

  // ---------------- AI Tutor Feature ----------------
  getIt.registerFactory(
    () => ChatBloc(
      getGeminiResponse: getIt<SendChatMessageUseCase>(),
    ),
  );

  // ---------------- Home Feature ----------------
  await home_di.initHomeFeature();


  // Theme BLoC
  getIt.registerFactory(() => ThemeBloc());

    // ---------------- Notification Feature ----------------
  getIt.registerLazySingleton(
    () => NotificationBloc(
      getNotificationListUseCase: getIt<GetNotificationListUseCase>(),
      addNotificationUseCase: getIt(),
      markAsReadUseCase: getIt(),
      deleteNotificationUseCase: getIt(),
      clearNotificationsUseCase: getIt(),
      markAllAsReadUseCase: getIt(),
    ),
  );

}
