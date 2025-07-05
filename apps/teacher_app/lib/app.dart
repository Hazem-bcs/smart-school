import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'injection_container.dart' as di;
import 'widgets/connectivity_listener.dart';
import 'blocs/sensitive_connectivity/connectivity_bloc.dart';
import 'features/auth/presentation/blocs/auth_bloc.dart';
import 'routing/app_routes.dart';

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
      ],
      child: Sizer(
        builder: (context, orientation, screenType) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'app_title'.tr(),
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              useMaterial3: true,
              fontFamily: 'Roboto',
            ),
            initialRoute: AppRoutes.splash,
            onGenerateRoute: AppRoutes.generateRoute,
            builder: (context, child) {
              return ConnectivityListener(child: child!);
            },
          );
        },
      ),
    );
  }
} 