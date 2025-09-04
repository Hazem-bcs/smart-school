import 'package:auth/domain/auth_repository.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:core/blocs/theme/theme_bloc.dart';
import 'package:core/blocs/theme/theme_event.dart';
import 'package:core/blocs/theme/theme_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sizer/sizer.dart';

// Core app imports
import 'firebase_options.dart';
import 'injection_container.dart' as di;

// Feature imports - organized by feature
import 'blocs/sensitive_connectivity/connectivity_bloc.dart';
import 'features/authentication/presentation/blocs/auth_bloc.dart';
import 'features/authentication/presentation/cuibts/on_boarding_cubit.dart';
import 'services/notification_service.dart';
import 'widgets/app_exports.dart';

// Routing imports
import 'routing/index.dart';
import 'features/authentication/presentation/pages/splash_page.dart';

/// Main entry point of the Smart School application
void main() async {
  await _initializeApp();
  runApp(const MyApp());
}

/// Initialize all app dependencies and services
Future<void> _initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  // get base url from github 
  // Constants.init();
  // Initialize localization
  await EasyLocalization.ensureInitialized();
  
  // Setup dependency injection
  await di.setupDependencies();
  
  // Initialize Firebase
  await _initializeFirebase();
  
  // Initialize notification service
  NotificationService.initializeNotification();
}

/// Initialize Firebase with background message handling
Future<void> _initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  FirebaseMessaging.onBackgroundMessage(
    NotificationService.firebaseMessagingBackgroundHandler,
  );
}

/// Main application widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const AppWithProviders(),
    );
  }
}

/// Application with core BLoC providers only
/// Feature-specific BLoCs are now handled in app_routes.dart with lazy loading
class AppWithProviders extends StatelessWidget {
  const AppWithProviders({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Core providers - needed globally and lightweight
        BlocProvider(
          create: (context) => ConnectivityBloc(connectivity: Connectivity()),
        ),
        BlocProvider(
          create: (context) => ThemeBloc()..add(InitializeTheme()),
        ),
        
        // Authentication providers - needed globally for app state
        BlocProvider(create: (context) => di.getIt<AuthBloc>()),
        BlocProvider(
          create: (context) => OnboardingCubit(di.getIt<AuthRepository>())
            ..checkOnboardingStatus(),
        ),
        
        // Note: NotificationBloc removed from global providers
        // It will be created lazily when needed in specific routes
      ],
      child: const AppWithTheme(),
    );
  }
}

/// Application with theme management
class AppWithTheme extends StatelessWidget {
  const AppWithTheme({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        final theme = _getTheme(themeState);
        final themeMode = _getThemeMode(themeState);
        
        return Sizer(
          builder: (context, orientation, screenType) {
            return MaterialApp(
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              debugShowCheckedModeBanner: false,
              title: 'Smart School',
              home: const SplashPage(),
              onGenerateRoute: AppRouter.generateRoute,
              theme: theme,
              darkTheme: theme,
              themeMode: themeMode,
            );
          },
        );
      },
    );
  }

  /// Get theme based on current theme state
  ThemeData _getTheme(ThemeState themeState) {
    if (themeState is ThemeLoaded) {
      return themeState.currentTheme;
    }
    return ThemeData.light();
  }

  /// Get theme mode based on current theme state
  ThemeMode _getThemeMode(ThemeState themeState) {
    if (themeState is ThemeLoaded) {
      return themeState.themeMode;
    }
    return ThemeMode.system;
  }
}

/// Initial route page that handles authentication and onboarding logic
class InitialRoutePage extends StatelessWidget {
  const InitialRoutePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          Navigator.of(context).pushReplacementNamed('/home');
        } else if (state is Unauthenticated) {
          _navigateBasedOnBoarding(context);
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthChecking) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          
          // Check authentication status when page loads
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<AuthBloc>().add(CheckAuthenticationStatusEvent());
          });
          
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }

  Future<void> _navigateBasedOnBoarding(BuildContext context) async {
    final bool hasSeenOnboarding = await context.read<OnboardingCubit>().checkOnboardingStatus();
    if (context.mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        !hasSeenOnboarding ? '/onBoarding' : '/login',
        (route) => false,
      );
    }
  }
}
