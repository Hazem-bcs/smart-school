// Core and Auth packages
import 'package:get_it/get_it.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:core/injection_container.dart' as core_di;
import 'package:auth/injection_container.dart' as auth_di;
import 'package:auth/domain/usecases/cheakauthstatus_usecase.dart';
import 'package:auth/domain/usecases/login_usecase.dart';

// BLoCs
import 'features/auth/presentation/blocs/auth_bloc.dart';
import 'features/classes/presentation/blocs/classes_bloc.dart';
import 'features/home/presentation/blocs/home_bloc.dart';
import 'features/settings/presentation/blocs/settings_bloc.dart';
import 'features/profile/presentation/blocs/profile_bloc.dart';
import 'blocs/sensitive_connectivity/connectivity_bloc.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // Setup core and auth dependencies
  await core_di.setupCoreDependencies(getIt);
  await auth_di.setupAuthDependencies(getIt);
  
  // Connectivity BLoC
  getIt.registerFactory(() => ConnectivityBloc(connectivity: Connectivity()));
  
  // Auth BLoC with auth package use cases
  getIt.registerFactory(() => AuthBloc(
    checkAuthStatusUseCase: getIt<CheckAuthStatusUseCase>(),
    loginUseCase: getIt<LoginUseCase>(),
  ));
  
  // Classes BLoC
  getIt.registerFactory(() => ClassesBloc());
  
  // Home BLoC
  getIt.registerFactory(() => HomeBloc());
  
  // Settings BLoC
  getIt.registerFactory(() => SettingsBloc());
  
  // Profile BLoC
  getIt.registerFactory(() => ProfileBloc());
}