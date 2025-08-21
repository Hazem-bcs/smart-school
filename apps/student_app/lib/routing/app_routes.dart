import 'package:auth/domain/usecases/cheakauthstatus_usecase.dart';
import 'package:auth/domain/usecases/login_usecase.dart';
import 'package:auth/domain/usecases/logout_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/authentication/presentation/blocs/auth_bloc.dart';
import '../features/authentication/presentation/pages/login_page.dart';
import '../features/authentication/presentation/pages/splash_page.dart';
import '../../injection_container.dart' as di;

class AppRoutes {
  // Route names
  static const String splash = '/splash';
  static const String login = '/login';
  static const String home = '/home';
  static const String scheduleZoom = '/schedule-zoom';
  static const String newAssignment = '/new-assignment';

  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String settings = '/settings';
  static const String changePassword = '/change-password';
  static const String aboutApp = '/about-app';
  static const String helpFaq = '/help-faq';
  static const String assignments = '/assignments';
  static const String schedule = '/schedule';
  static const String assignmentSubmission = '/assignment-submission';

  // Route generator with BLoC initialization
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final routeName = settings.name;

    switch (routeName) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashPage(),
          settings: settings,
        );

      case login:
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(
                create:
                    (_) => AuthBloc(
                      checkAuthStatusUseCase:
                          di.getIt<CheckAuthStatusUseCase>(),
                      loginUseCase: di.getIt<LoginUseCase>(), logoutUseCase: di.getIt<LogoutUseCase>(),
                      // logoutUseCase: di.getIt<LogoutUseCase>(),
                    ),
                child: const LoginPage(),
              ),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
                body: Center(
                  child: Text('Route ${routeName ?? 'unknown'} not found'),
                ),
              ),
        );
    }
  }
}

