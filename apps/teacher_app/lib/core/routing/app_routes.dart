import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_app/features/assignment_submission/presentation/blocs/submission_bloc.dart';
import 'package:teacher_app/features/assignment_submission/presentation/ui/pages/assignment_submission_screen.dart';
import 'package:teacher_app/features/home/domain/usecases/get_assignments_usecase.dart';
import 'package:teacher_app/features/new_assignment/presentation/blocs/new_assignment_bloc.dart';
import 'package:teacher_app/features/new_assignment/presentation/ui/pages/new_assignment_page.dart';
import '../../../features/auth/presentation/ui/pages/splash_page.dart';
import '../../../features/auth/presentation/ui/pages/login_page.dart';
import '../../../features/home/presentation/ui/pages/home_page.dart';

import '../../../features/profile/presentation/ui/pages/profile_page.dart';
import '../../../features/profile/presentation/ui/pages/edit_profile_page.dart';
import '../../../features/settings/presentation/pages/settings_page.dart';
import '../../../features/settings/presentation/pages/about_app_page.dart';
import '../../../features/settings/presentation/pages/help_faq_page.dart';
import '../../../features/assignment/presentation/ui/pages/assignments_page.dart';

import '../../../features/schedule/presentation/ui/pages/schedule_page.dart';
import '../../../features/zoom_meeting/presentation/ui/pages/schedule_meeting_page.dart';
import 'package:password/presentation/pages/change_password_page.dart';
import 'package:password/presentation/blocs/password_bloc.dart';
import '../../../features/auth/presentation/blocs/auth_bloc.dart';

import '../../../features/home/presentation/blocs/home_bloc.dart';
import '../../../features/home/domain/usecases/get_classes_usecase.dart';

import '../../../features/home/domain/usecases/get_notifications_usecase.dart';
import '../../../features/zoom_meeting/presentation/blocs/zoom_meeting_bloc.dart';
import '../../../features/zoom_meeting/domain/usecases/schedule_meeting_usecase.dart';
import '../../../features/zoom_meeting/domain/usecases/get_available_classes_usecase.dart';
import '../../../features/zoom_meeting/domain/usecases/get_meeting_options_usecase.dart';
import '../../../features/profile/presentation/blocs/profile_bloc.dart';
import '../../../features/profile/domain/usecases/get_profile_usecase.dart';
import '../../../features/profile/domain/usecases/update_profile_usecase.dart';
import '../../../injection_container.dart' as di;
import '../../features/auth/domain/usecases/check_auth_status_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import 'package:teacher_app/features/assignment/presentation/blocs/assignment_bloc.dart';

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
          builder: (_) => BlocProvider(
            create: (_) => AuthBloc(
              checkAuthStatusUseCase: di.getIt<CheckAuthStatusUseCase>(),
              loginUseCase: di.getIt<LoginUseCase>(),
              logoutUseCase: di.getIt<LogoutUseCase>(),
            ),
            child: const LoginPage(),
          ),
          settings: settings,
        );
        
      case home:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => HomeBloc(
              getClassesUseCase: di.getIt<GetHomeClassesUseCase>(),
              getAssignmentsUseCase: di.getIt<GetAssignmentsUseCase>(),
              getNotificationsUseCase: di.getIt<GetNotificationsUseCase>(),
            ),
            child: const HomePage(),
          ),
          settings: settings,
        );
        
      case scheduleZoom:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => ZoomMeetingBloc(
              scheduleMeetingUseCase: di.getIt<ScheduleMeetingUseCase>(),
              getAvailableClassesUseCase: di.getIt<GetAvailableClassesUseCase>(),
              getMeetingOptionsUseCase: di.getIt<GetMeetingOptionsUseCase>(),
            ),
            child: const ScheduleMeetingPage(),
          ),
          settings: settings,
        );
        

        
      case profile:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => ProfileBloc(
              getProfileUseCase: di.getIt<GetProfileUseCase>(),
              updateProfileUseCase: di.getIt<UpdateProfileUseCase>(),
            ),
            child: const ProfilePage(),
          ),
          settings: settings,
        );
        
      case editProfile:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => ProfileBloc(
              getProfileUseCase: di.getIt<GetProfileUseCase>(),
              updateProfileUseCase: di.getIt<UpdateProfileUseCase>(),
            ),
            child: const EditProfilePage(),
          ),
          settings: settings,
        );
        
      case AppRoutes.settings:
        return MaterialPageRoute(
          builder: (_) => const SettingsScreen(),
          settings: settings,
        );
        
      case changePassword:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => di.getIt<PasswordBloc>(),
            child: const ChangePasswordPage(),
          ),
          settings: settings,
        );
        
      case aboutApp:
        return MaterialPageRoute(
          builder: (_) => const AboutAppPage(),
          settings: settings,
        );
        
      case helpFaq:
        return MaterialPageRoute(
          builder: (_) => const HelpFaqPage(),
          settings: settings,
        );
        
        case assignments:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => di.getIt<AssignmentBloc>(),
            child: const AssignmentsPage(),
          ),
          settings: settings,
        );
        
        case newAssignment:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_){return di.getIt<NewAssignmentBloc>();},
            child: const NewAssignmentPage(),
          ),
          settings: settings,
        );
        
        case schedule:
        return MaterialPageRoute(
          builder: (_) => const SchedulePage(),
          settings: settings,
        );
        
      case assignmentSubmission:
        final assignmentId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => di.getIt<SubmissionBloc>(),
            child: AssignmentSubmissionScreen(assignmentId: assignmentId),
          ),
          settings: settings,
        );
        
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Route ${routeName ?? 'unknown'} not found'),
            ),
          ),
        );
    }
  }
} 