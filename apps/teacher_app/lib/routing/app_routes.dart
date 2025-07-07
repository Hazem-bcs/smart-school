import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/presentation/ui/pages/splash_page.dart';
import '../../features/auth/presentation/ui/pages/login_page.dart';
import '../../features/home/presentation/ui/pages/home_page.dart';
import '../../features/classes/presentation/ui/pages/classes_page.dart';
import '../../features/profile/presentation/ui/pages/profile_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/settings/presentation/pages/about_app_page.dart';
import '../../features/settings/presentation/pages/help_faq_page.dart';
import 'package:password/presentation/pages/change_password_page.dart';
import 'package:password/presentation/blocs/password_bloc.dart';
import '../../features/auth/presentation/blocs/auth_bloc.dart';
import '../../features/classes/presentation/blocs/classes_bloc.dart';
import '../../features/home/presentation/blocs/home_bloc.dart';
import '../../features/profile/presentation/blocs/profile_bloc.dart';
import '../../features/settings/presentation/blocs/settings_bloc.dart';
import '../../injection_container.dart' as di;
import 'package:auth/domain/usecases/cheakauthstatus_usecase.dart';
import 'package:auth/domain/usecases/login_usecase.dart';
import 'package:password/injection_container.dart' as password_di;

class AppRoutes {
  // Route names
  static const String splash = '/splash';
  static const String login = '/login';
  static const String home = '/home';
  static const String classes = '/classes';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String changePassword = '/change-password';
  static const String aboutApp = '/about-app';
  static const String helpFaq = '/help-faq';
  
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
            ),
            child: const LoginPage(),
          ),
          settings: settings,
        );
        
      case home:
        final args = settings.arguments as Map<String, dynamic>?;
        final className = args?['className'] as String? ?? 'Default Class';
        
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => HomeBloc(),
            child: HomePage(className: className),
          ),
          settings: settings,
        );
        
      case classes:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => ClassesBloc(),
            child: const ClassesPage(),
          ),
          settings: settings,
        );
        
      case profile:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => ProfileBloc(),
            child: const ProfilePage(),
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