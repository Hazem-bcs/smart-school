import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_school/features/home/presentation/pages/home_page.dart';
import 'package:smart_school/features/authentication/presentation/pages/splash_page.dart';
import 'package:smart_school/features/homework/presentation/blocs/homework_bloc.dart';
import 'blocs/fetch_image/fetch_image_cubit.dart';
import 'blocs/focus_node_cubit/focus_node_cubit.dart';
import 'blocs/sensitive_connectivity/connectivity_bloc.dart';
import 'features/authentication/domain/auth_repository.dart';
import 'features/authentication/presentation/blocs/auth_bloc.dart';
import 'dependency_injection.dart' as di;
import 'features/authentication/presentation/cuibts/on_boarding_cubit.dart';
import 'features/authentication/presentation/pages/login_page.dart';
import 'features/authentication/presentation/pages/on_boarding.dart';
import 'features/home/presentation/widgets/app_drawer.dart';
import 'features/homework/presentation/pages/homework_page.dart';
import 'features/homework/presentation/pages/one_homework_page.dart';
import 'features/post/presentation/pages/add_post_page.dart';
import 'features/teacher/presentation/pages/teacher_page.dart';
import 'features/teacher/presentation/pages/teachers_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await di.setupDependencies();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ConnectivityBloc(connectivity: Connectivity()),
        ),
        BlocProvider(
          create: (context) => di.getIt<AuthBloc>(),
        ),
        BlocProvider(
          create: (context) => OnboardingCubit(di.getIt<AuthRepository>())..checkOnboardingStatus(),
        ),
        BlocProvider(
          create: (BuildContext context) => FocusNodeCubit(),
        ),
        BlocProvider(
          create: (BuildContext context) => FetchImageCubit(),
        ),
        BlocProvider(create: (context) => di.getIt<HomeworkBloc>()),
      ],
      child: MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        home: const SplashPage(),
        routes: {
          '/onBoarding': (context) => OnBoardingPage(),
          '/login': (context) => LoginPage(),
          '/home' : (context) => HomePage(),
          '/addPost' : (context) => AddPostPage(),
          '/teachersPage' : (context) => TeachersPage(),
          '/teacherPage' : (context) => TeacherPage(),
          '/appDrawerWidget' : (context) => AppDrawerWidget(),
          '/homeWorkPage' : (context) => HomeworkPage(),
          '/oneHomeworkPage' : (context) => OneHomeworkPage(),
      },
      ),
    );
  }
}