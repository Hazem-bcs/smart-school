// Core and Auth packages
import 'package:get_it/get_it.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:core/network/dio_client.dart';
import 'package:core/injection_container.dart' as core_di;
import 'package:auth/injection_container.dart' as auth_di;
import 'package:password/injection_container.dart' as password_di;
import 'package:teacher_app/features/home/domain/usecases/get_assignments_usecase.dart';
import 'features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/data/data_sources/auth_local_data_source.dart';
import 'features/auth/data/data_sources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';

// Home feature
import 'features/home/domain/usecases/get_classes_usecase.dart';
import 'features/home/domain/usecases/get_notifications_usecase.dart';
import 'features/home/data/repositories/home_repository_impl.dart';
import 'features/home/data/data_sources/home_remote_data_source.dart';
import 'features/home/domain/repositories/home_repository.dart';

// Zoom Meeting feature
import 'features/zoom_meeting/domain/usecases/schedule_meeting_usecase.dart';
import 'features/zoom_meeting/domain/usecases/get_available_classes_usecase.dart';
import 'features/zoom_meeting/domain/usecases/get_meeting_options_usecase.dart';
import 'features/zoom_meeting/data/repositories/zoom_meeting_repository_impl.dart';
import 'features/zoom_meeting/data/data_sources/zoom_meeting_remote_data_source.dart';
import 'features/zoom_meeting/domain/repositories/zoom_meeting_repository.dart';



// BLoCs
import 'features/auth/presentation/blocs/auth_bloc.dart';
import 'features/home/presentation/blocs/home_bloc.dart';
import 'features/settings/presentation/blocs/settings_bloc.dart';
import 'features/profile/presentation/blocs/profile_bloc.dart';
import 'features/zoom_meeting/presentation/blocs/zoom_meeting_bloc.dart';
import 'blocs/sensitive_connectivity/connectivity_bloc.dart';

// Profile feature
import 'features/profile/data/data_sources/profile_local_data_source.dart';
import 'features/profile/data/data_sources/profile_remote_data_source.dart';
import 'features/profile/data/repositories/profile_repository_impl.dart';
import 'features/profile/domain/repositories/profile_repository.dart';
import 'features/profile/domain/usecases/get_profile_usecase.dart';
import 'features/profile/domain/usecases/update_profile_usecase.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // Setup core and auth dependencies
  await core_di.setupCoreDependencies(getIt);
  await auth_di.setupAuthDependencies(getIt);
  
  // Setup password dependencies
  await password_di.setupPasswordDependencies(getIt);
  
  // Auth feature dependencies (local)
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(),
  );
  
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dioClient: getIt<DioClient>()),
  );
  
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
      localDataSource: getIt<AuthLocalDataSource>(),
    ),
  );
  
  getIt.registerLazySingleton(() => LoginUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => CheckAuthStatusUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt<AuthRepository>()));
  
  // Home feature dependencies
  getIt.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(),
  );
  
  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(getIt<HomeRemoteDataSource>()),
  );
  
  getIt.registerLazySingleton(() => GetClassesUseCase(getIt<HomeRepository>()));
  getIt.registerLazySingleton(() => GetNotificationsUseCase(getIt<HomeRepository>()));
  
  // Zoom Meeting feature dependencies
  getIt.registerLazySingleton<ZoomMeetingRemoteDataSource>(
    () => ZoomMeetingRemoteDataSourceImpl(),
  );
  
  getIt.registerLazySingleton<ZoomMeetingRepository>(
    () => ZoomMeetingRepositoryImpl(getIt<ZoomMeetingRemoteDataSource>()),
  );
  
  getIt.registerLazySingleton(() => ScheduleMeetingUseCase(getIt<ZoomMeetingRepository>()));
  getIt.registerLazySingleton(() => GetAvailableClassesUseCase(getIt<ZoomMeetingRepository>()));
  getIt.registerLazySingleton(() => GetMeetingOptionsUseCase(getIt<ZoomMeetingRepository>()));
  
  // Assignment feature dependencies
  
  // Connectivity BLoC
  getIt.registerFactory(() => ConnectivityBloc(connectivity: Connectivity()));
  
  // Auth BLoC with local auth use cases
  getIt.registerFactory(() => AuthBloc(
    checkAuthStatusUseCase: getIt<CheckAuthStatusUseCase>(),
    loginUseCase: getIt<LoginUseCase>(),
    logoutUseCase: getIt<LogoutUseCase>(),
  ));
  // Home BLoC
  getIt.registerFactory(() => HomeBloc(
    getClassesUseCase: getIt<GetClassesUseCase>(),
    getAssignmentsUseCase: getIt<GetAssignmentsUseCase>(),
    getNotificationsUseCase: getIt<GetNotificationsUseCase>(),
  ));
  
  // Zoom Meeting BLoC
  getIt.registerFactory(() => ZoomMeetingBloc(
    scheduleMeetingUseCase: getIt<ScheduleMeetingUseCase>(),
    getAvailableClassesUseCase: getIt<GetAvailableClassesUseCase>(),
    getMeetingOptionsUseCase: getIt<GetMeetingOptionsUseCase>(),
  ));
  
  // Settings BLoC
  getIt.registerFactory(() => SettingsBloc());
  
  // Profile feature dependencies
  getIt.registerLazySingleton<ProfileLocalDataSource>(
    () => ProfileLocalDataSourceImpl(),
  );

  getIt.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(dioClient: getIt<DioClient>()),
  );

  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      remoteDataSource: getIt<ProfileRemoteDataSource>(),
      localDataSource: getIt<ProfileLocalDataSource>(),
    ),
  );

  getIt.registerLazySingleton(() => GetProfileUseCase(getIt<ProfileRepository>()));
  getIt.registerLazySingleton(() => UpdateProfileUseCase(getIt<ProfileRepository>()));

  // Profile BLoC
  getIt.registerFactory(() => ProfileBloc(
    getProfileUseCase: getIt<GetProfileUseCase>(),
    updateProfileUseCase: getIt<UpdateProfileUseCase>(),
  ));

  // Assignment BLoC
  
}