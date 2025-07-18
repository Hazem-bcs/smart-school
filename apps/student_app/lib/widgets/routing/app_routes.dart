import 'package:auth/domain/usecases/cheakauthstatus_usecase.dart';
import 'package:auth/domain/usecases/login_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/authentication/presentation/blocs/auth_bloc.dart';
import '../../features/authentication/presentation/pages/login_page.dart';
import '../../features/authentication/presentation/pages/splash_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/profile/presentation/bolcs/profile_bloc.dart';
import '../../features/schedule/presentation/pages/schedule_page.dart';
import '../../../injection_container.dart' as di;

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
                      loginUseCase: di.getIt<LoginUseCase>(),
                      // logoutUseCase: di.getIt<LogoutUseCase>(),
                    ),
                child: const LoginPage(),
              ),
          settings: settings,
        );

      // case home:
      //   return MaterialPageRoute(
      //     builder: (_) => BlocProvider(
      //       create: (_) => HomeBloc(
      //         getClassesUseCase: di.getIt<GetHomeClassesUseCase>(),
      //         getAssignmentsUseCase: di.getIt<GetAssignmentsUseCase>(),
      //         getNotificationsUseCase: di.getIt<GetNotificationsUseCase>(),
      //       ),
      //       child: const HomePage(),
      //     ),
      //     settings: settings,
      //   );

      // case editProfile:
      //   return MaterialPageRoute(
      //     builder: (_) => BlocProvider(
      //       create: (_) => ProfileBloc(
      //         getProfileUseCase: di.getIt<GetProfileUseCase>(),
      //         updateProfileUseCase: di.getIt<UpdateProfileUseCase>(),
      //       ),
      //       child: const EditProfilePage(),
      //     ),
      //     settings: settings,
      //   );
      //
      // case AppRoutes.settings:
      //   return MaterialPageRoute(
      //     builder: (_) => const SettingsScreen(),
      //     settings: settings,
      //   );
      //
      // case changePassword:
      //   return MaterialPageRoute(
      //     builder: (_) => BlocProvider(
      //       create: (_) => di.getIt<PasswordBloc>(),
      //       child: const ChangePasswordPage(),
      //     ),
      //     settings: settings,
      //   );
      //
      // case aboutApp:
      //   return MaterialPageRoute(
      //     builder: (_) => const AboutAppPage(),
      //     settings: settings,
      //   );
      //
      // case helpFaq:
      //   return MaterialPageRoute(
      //     builder: (_) => const HelpFaqPage(),
      //     settings: settings,
      //   );
      //
      //   case assignments:
      //   return MaterialPageRoute(
      //     builder: (_) => BlocProvider(
      //       create: (_) => di.getIt<AssignmentBloc>(),
      //       child: const AssignmentsPage(),
      //     ),
      //     settings: settings,
      //   );
      //
      //   case newAssignment:
      //   return MaterialPageRoute(
      //     builder: (_) => BlocProvider(
      //       create: (_){return di.getIt<NewAssignmentBloc>();},
      //       child: const NewAssignmentPage(),
      //     ),
      //     settings: settings,
      //   );
      //
      //   case schedule:
      //   return MaterialPageRoute(
      //     builder: (_) => const SchedulePage(),
      //     settings: settings,
      //   );
      //
      // case assignmentSubmission:
      //   final assignmentId = settings.arguments as String;
      //   return MaterialPageRoute(
      //     builder: (_) => BlocProvider(
      //       create: (_) => di.getIt<SubmissionBloc>(),
      //       child: AssignmentSubmissionScreen(assignmentId: assignmentId),
      //     ),
      //     settings: settings,
      //   );
      //
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
