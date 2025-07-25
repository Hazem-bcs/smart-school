import 'package:auth/domain/auth_repository.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:smart_school/features/atendance/presentation/blocs/attendance_bloc.dart';
import 'package:smart_school/features/home/presentation/pages/home_page.dart';
import 'package:smart_school/features/homework/presentation/blocs/home_work_bloc/homework_bloc.dart';
import 'package:smart_school/features/homework/presentation/blocs/question_bloc/question_bloc.dart';
import 'package:smart_school/features/new_assignment/presentation/pages/new_assignment_page.dart';
import 'package:smart_school/features/notification/presintation/bloc/notification_bloc.dart';
import 'package:smart_school/features/schedule/presentation/pages/schedule_page.dart';
import 'package:smart_school/features/settings/presentation/pages/settings_page.dart';
import 'package:smart_school/features/subject/presentation/blocs/subject_list/subject_list_bloc.dart';
import 'package:smart_school/features/zoom/presentation/bloc/zoom_meetings_bloc.dart';
import 'blocs/sensitive_connectivity/connectivity_bloc.dart';
import 'features/ai_tutor/presentation/bloc/tutor_chat_bloc.dart';
import 'features/ai_tutor/presentation/pages/tutor_chat_page.dart';
import 'features/atendance/presentation/pages/attendance_page.dart';
import 'features/authentication/presentation/blocs/auth_bloc.dart';
import 'features/notification/presintation/pages/notification_page.dart';
import 'injection_container.dart' as di;
import 'features/authentication/presentation/cuibts/on_boarding_cubit.dart';
import 'features/authentication/presentation/pages/login_page.dart';
import 'features/authentication/presentation/pages/on_boarding.dart';
import 'features/dues/presentation/blocs/dues_bloc.dart';
import 'features/dues/presentation/pages/dues_page.dart';
import 'features/homework/presentation/pages/homework_page.dart';

import 'features/profile/presentation/bolcs/profile_bloc.dart';
import 'features/profile/presentation/pages/profile_page.dart';
import 'features/resource/presintation/blocs/resource_bloc.dart';
import 'features/resource/presintation/pages/resource_page.dart';
import 'features/subject/presentation/blocs/subject/subject_bloc.dart';
import 'features/subject/presentation/pages/subjects_page.dart';
import 'features/teacher/presentation/pages/teachers_page.dart';
import 'package:smart_school/widgets/app_exports.dart';
import 'package:sizer/sizer.dart';
import 'features/teacher/presentation/blocs/teacher_list_bloc.dart';
import 'features/teacher/presentation/blocs/teacher_details_bloc.dart';

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
        BlocProvider(create: (context) => di.getIt<AuthBloc>()),
        BlocProvider(
          create:
              (context) =>
                  OnboardingCubit(di.getIt<AuthRepository>())
                    ..checkOnboardingStatus(),
        ),
        BlocProvider(create: (context) => di.getIt<HomeworkBloc>()),
        BlocProvider(create: (context) => di.getIt<QuestionBloc>()),
        BlocProvider(create: (context) => di.getIt<DuesBloc>()),
        BlocProvider(create: (context) => di.getIt<ProfileBloc>()),
        BlocProvider(create: (context) => di.getIt<SubjectBloc>()),
        BlocProvider(create: (context) => di.getIt<SubjectListBloc>()),
        BlocProvider(create: (context) => di.getIt<TeacherListBloc>()),
        BlocProvider(create: (context) => di.getIt<TeacherDetailsBloc>()),
        BlocProvider(create: (context) => di.getIt<NotificationBloc>()),
        BlocProvider(create: (context) => di.getIt<ResourceBloc>()),
        BlocProvider(create: (context) => di.getIt<ChatBloc>()),
        BlocProvider(create: (context) => di.getIt<AttendanceBloc>()),
        BlocProvider(create: (context) => di.getIt<ZoomMeetingsBloc>()),
      ],
      child: Sizer(
        builder: (context, orientation, screenType) {
          return MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            home: const HomePage(),
            routes: {
              '/onBoarding': (context) => OnBoardingPage(),
              '/login': (context) => LoginPage(),
              '/home': (context) => HomePage(),
              '/teacherPage': (context) => TeachersPage(),
              '/appDrawerWidget': (context) => AppDrawerWidget(),
              '/homeWorkPage': (context) => HomeworkPage(),
              '/duesPage': (context) => DuesPage(),
              '/profilePage': (context) => ProfilePage(),
              '/subjectsPage': (context) => SubjectsPage(),
              '/tutorChatView': (context) => TutorChatView(),
              '/attendancePage': (context) => AttendancePage(),
              '/resourcesPage': (context) => ResourcesPage(),
              '/notificationPage': (context) => NotificationPage(),
              '/settings': (context) => SettingsScreen(),
              '/schedule': (context) => SchedulePage(),
              '/assignments': (context) => NewAssignmentPage(),
            },
          );
        },
      ),
    );
  }
}
