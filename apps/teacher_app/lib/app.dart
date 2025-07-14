import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:core/theme/index.dart';
import 'injection_container.dart' as di;
import 'widgets/connectivity_listener.dart';
import 'blocs/sensitive_connectivity/connectivity_bloc.dart';
import 'blocs/theme/theme_bloc.dart';
import 'features/auth/presentation/blocs/auth_bloc.dart';
import 'routing/app_routes.dart';
import 'theme/teacher_theme.dart';

class TeacherApp extends StatelessWidget {
  const TeacherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Connectivity BLoC - ضروري للتطبيق كاملاً
        BlocProvider(
          create: (context) => di.getIt<ConnectivityBloc>(),
        ),
        // Auth BLoC - ضروري للتحقق من حالة المصادقة
        BlocProvider(
          create: (context) => di.getIt<AuthBloc>(),
        ),
        // Theme BLoC - لإدارة الثيمات
        BlocProvider(
          create: (context) => ThemeBloc()..add(InitializeTheme()),
        ),
      ],
      child: Sizer(
        builder: (context, orientation, screenType) {
          return BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, themeState) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'app_title'.tr(),
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                
                // Use dynamic theme based on ThemeBloc state
                theme: _getLightTheme(),
                darkTheme: _getDarkTheme(),
                themeMode: _getThemeMode(themeState),
                
                initialRoute: AppRoutes.assignments,
                onGenerateRoute: AppRoutes.generateRoute,
                builder: (context, child) {
                  return ConnectivityListener(child: child!);
                },
              );
            },
          );
        },
      ),
    );
  }

  // Get light theme with teacher accent
  ThemeData _getLightTheme() {
    return TeacherTheme.lightTheme;
  }

  // Get dark theme with teacher accent
  ThemeData _getDarkTheme() {
    return TeacherTheme.darkTheme;
  }

  // Get theme mode based on ThemeBloc state
  ThemeMode _getThemeMode(ThemeState themeState) {
    if (themeState is ThemeLoaded) {
      return themeState.themeMode;
    }
    return ThemeMode.system; // Default to system theme
  }
} 