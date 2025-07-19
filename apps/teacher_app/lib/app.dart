import 'package:core/blocs/sensitive_connectivity/connectivity_bloc.dart';
import 'package:core/widgets/connectivity_listener.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:core/blocs/theme/theme_bloc.dart';
import 'package:core/blocs/theme/theme_state.dart';
import 'package:core/blocs/theme/theme_event.dart';
import 'features/settings/presentation/blocs/settings_bloc.dart';
import 'injection_container.dart' as di;
import 'features/auth/presentation/blocs/auth_bloc.dart';
import 'core/routing/app_routes.dart';

class TeacherApp extends StatelessWidget {
  const TeacherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Connectivity BLoC - ضروري للتطبيق كاملاً
        BlocProvider(create: (context) => di.getIt<ConnectivityBloc>()),
        // Auth BLoC - ضروري للتحقق من حالة المصادقة
        BlocProvider(create: (context) => di.getIt<AuthBloc>()),
        // Theme BLoC - لإدارة الثيمات
        BlocProvider(create: (context) => ThemeBloc()..add(InitializeTheme())),
        BlocProvider(create: (context) => di.getIt<SettingsBloc>()),
      ],
      child: Sizer(
        builder: (context, orientation, screenType) {
          return BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, themeState) {
              final theme =
                  themeState is ThemeLoaded
                      ? themeState.currentTheme
                      : ThemeData.light();
              final themeMode =
                  themeState is ThemeLoaded
                      ? themeState.themeMode
                      : ThemeMode.system;
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'app_title'.tr(),
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                theme: theme,
                darkTheme: theme,
                themeMode: themeMode,
                initialRoute: AppRoutes.splash,
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
}
