import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth/domain/usecases/cheakauthstatus_usecase.dart';
import 'package:auth/domain/usecases/login_usecase.dart';
import 'package:auth/domain/usecases/logout_usecase.dart';
import 'package:auth/domain/auth_repository.dart';
import 'package:attendance/presentation/blocs/attendance_bloc.dart';
import 'package:attendance/presentation/blocs/attendance_details_bloc.dart';
import 'package:attendance/presentation/pages/attendance_page.dart';
import 'package:smart_school/features/quiz/presentation/pages/one_quiz_page.dart';
import 'package:smart_school/features/teacher/presentation/pages/teacher_details_page.dart';
import '../injection_container.dart' as di;

// Feature imports
import '../features/authentication/presentation/blocs/auth_bloc.dart';
import '../features/authentication/presentation/pages/login_page.dart';
import '../features/authentication/presentation/pages/splash_page.dart';
import '../features/authentication/presentation/pages/on_boarding.dart';
import '../features/authentication/presentation/cuibts/on_boarding_cubit.dart';
import '../features/home/presentation/bloc/home_bloc.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/quiz/presentation/blocs/home_work_bloc/homework_bloc.dart';
import '../features/quiz/presentation/blocs/question_bloc/question_bloc.dart';
import '../features/quiz/presentation/pages/quiz_page.dart';
import '../features/dues/presentation/blocs/dues_bloc.dart';
import '../features/dues/presentation/pages/dues_page.dart';
import '../features/profile/presentation/bolcs/profile_bloc.dart';
import '../features/profile/presentation/pages/profile_page.dart';
import '../features/resource/presintation/blocs/resource_bloc.dart';
import '../features/resource/presintation/pages/resource_page.dart';
import '../features/subject/presentation/blocs/subject/subject_bloc.dart';
import '../features/subject/presentation/blocs/subject_list/subject_list_bloc.dart';
import '../features/subject/presentation/pages/subjects_page.dart';
import '../features/subject/presentation/pages/subject_details_page.dart';
import '../features/teacher/presentation/blocs/teacher_list_bloc.dart';
import '../features/teacher/presentation/blocs/teacher_details_bloc.dart';
import '../features/teacher/presentation/pages/teachers_page.dart';
import '../features/notification/presintation/bloc/notification_bloc.dart';
import '../features/notification/presintation/pages/notification_page.dart';
import '../features/settings/presentation/blocs/settings_bloc.dart';
import '../features/settings/presentation/pages/settings_page.dart';
import '../features/settings/presentation/pages/about_app_page.dart';
import '../features/settings/presentation/pages/help_faq_page.dart';
import '../features/schedule/presentation/blocs/schedule_bloc.dart';
import '../features/schedule/presentation/pages/schedule_page.dart';
import '../features/new_assignment/domain/entities/assignment_entity.dart';
import '../features/new_assignment/presentation/pages/assignment_details_page.dart';
import '../features/new_assignment/presentation/pages/assignments_list_page.dart';
import '../features/ai_tutor/presentation/bloc/tutor_chat_bloc.dart';
import '../features/ai_tutor/presentation/pages/tutor_chat_page.dart';
import '../features/zoom/presentation/bloc/zoom_meetings_bloc.dart';
import '../features/zoom/presentation/pages/zoom_meetings_list_page.dart';
import '../widgets/app_exports.dart';

/// Centralized route management for Smart School Student App
class AppRoutes {
  // Core routes
  static const String splash = '/splash';
  static const String onBoarding = '/onBoarding';
  static const String login = '/login';
  static const String home = '/home';
  
  // Feature routes
  static const String homework = '/homeWorkPage';
  static const String dues = '/duesPage';
  static const String profile = '/profilePage';
  static const String subjects = '/subjectsPage';
  static const String teachers = '/teacherPage';
  static const String notifications = '/notificationPage';
  static const String resources = '/resourcesPage';
  static const String settingsPage = '/settings';
  static const String schedule = '/schedule';
  static const String assignments = '/assignments';
  static const String assignmentDetails = '/assignment_details';
  static const String tutorChat = '/tutorChatView';
  static const String attendance = '/attendancePage';
  static const String zoom = '/zoom';
  static const String teacherDetails = '/teacherDetails';
  static const String questions = '/questions';
  static const String subjectDetails = '/subjectDetails';
  
  // Settings sub-routes
  static const String aboutApp = '/about-app';
  static const String helpFaq = '/help-faq';
  
  // Navigation drawer
  static const String appDrawer = '/appDrawer';

  /// Generate routes with proper BLoC initialization
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final routeName = settings.name;
    
    switch (routeName) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashPage(),
          settings: settings,
        );
        
      case onBoarding:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => OnboardingCubit(di.getIt<AuthRepository>()),
            child: const OnBoardingPage(),
          ),
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
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => di.getIt<HomeBloc>()),
              BlocProvider(create: (_) => di.getIt<NotificationBloc>()),
            ],
            child: const HomePage(),
          ),
          settings: settings,
        );
        
      case homework:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => di.getIt<HomeworkBloc>(),
            child: const HomeworkPage(),
          ),
          settings: settings,
        );

      case questions:
        final questionId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => di.getIt<QuestionBloc>(),
            child: OneQuizPage(questionId: int.parse(questionId)),
          ),
          settings: settings,
        );
      case dues:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => di.getIt<DuesBloc>(),
            child: const DuesPage(),
          ),
          settings: settings,
        );
        
      case profile:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => di.getIt<ProfileBloc>(),
            child: const ProfilePage(),
          ),
          settings: settings,
        );
        
      case subjects:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => di.getIt<SubjectBloc>()),
              BlocProvider(create: (_) => di.getIt<SubjectListBloc>()),
            ],
            child: const SubjectsPage(),
          ),
          settings: settings,
        );
        
      case subjectDetails:
        final subjectId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => di.getIt<SubjectBloc>(),
            child: SubjectDetailsPage(subjectId: subjectId),
          ),
          settings: settings,
        );
        
      case teachers:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => di.getIt<TeacherListBloc>(),
            child: const TeachersPage(),
            ),
          settings: settings,
        );
        
        case teacherDetails:
          final teacherId = settings.arguments as int;
          return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => di.getIt<TeacherDetailsBloc>(),
              child: TeacherDetailsPage(teacherId: teacherId),
            ),
            settings: settings,
          );
        
      case notifications:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => di.getIt<NotificationBloc>(),
            child: const NotificationPage(),
          ),
          settings: settings,
        );
        
      case resources:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => di.getIt<ResourceBloc>(),
            child: const ResourcesPage(),
          ),
          settings: settings,
        );
        
      case settingsPage:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => di.getIt<SettingsBloc>(),
            child: const SettingsScreen(),
          ),
          settings: settings,
        );
        
      case schedule:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => di.getIt<ScheduleBloc>(),
            child: const SchedulePage(),
          ),
          settings: settings,
        );
        
      case assignments:
        return MaterialPageRoute(
          builder: (_) => const AssignmentsListPage(),
          settings: settings,
        );
        
      case assignmentDetails:
        final assignment = settings.arguments as AssignmentEntity;
        return MaterialPageRoute(
          builder: (_) => AssignmentDetailsPage(assignment: assignment),
          settings: settings,
        );
        
      case tutorChat:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => di.getIt<ChatBloc>(),
            child: const TutorChatView(),
          ),
          settings: settings,
        );
        
      case attendance:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => di.getIt<AttendanceBloc>()),
              BlocProvider(create: (_) => di.getIt<AttendanceDetailsBloc>()),
            ],
            child: const AttendancePage(),
          ),
          settings: settings,
        );
        
      case zoom:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => di.getIt<ZoomMeetingsBloc>(),
            child: const ZoomMeetingsListPage(),
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
        
      case appDrawer:
        return MaterialPageRoute(
          builder: (_) => const AppDrawerWidget(),
          settings: settings,
        );
        
      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Route not found',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Route: ${routeName ?? 'unknown'}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        );
    }
  }
}

