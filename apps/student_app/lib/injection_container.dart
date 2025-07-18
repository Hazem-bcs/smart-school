import 'package:auth/domain/usecases/cheakauthstatus_usecase.dart';
import 'package:auth/domain/usecases/login_usecase.dart';
import 'package:auth/injection_container.dart' as auth_di;
import 'package:core/injection_container.dart' as core_di;
import 'package:dues/domain/usecases/get_my_dues.dart';
import 'package:dues/injection_container.dart' as dues_di;
import 'package:get_it/get_it.dart';
import 'package:homework/domain/usecases/get_homework_use_case.dart';
import 'package:homework/domain/usecases/get_question_list_use_case.dart';
import 'package:homework/domain/usecases/submit_homework_usecase.dart';
import 'package:homework/injection_container.dart' as homework_di;
import 'package:notification/domain/use_cases/get_notification_list_use_case.dart';
import 'package:notification/injection_container.dart' as notification_di;
import 'package:profile/domain/use_cases/get_user_profile_use_case.dart';
import 'package:profile/injection_container.dart' as profile_di;
import 'package:resource/domain/use_cases/get_resource_list_use_case.dart';
import 'package:resource/injection_container.dart' as resource_di;
import 'package:subject/domain/use_cases/get_subject_list_use_case.dart';
import 'package:subject/domain/use_cases/get_subject_use_case.dart';
import 'package:subject/injection_container.dart' as subject_di;
import 'package:teacher_feat/domain/use_cases/get_teacher_by_id_use_case.dart';
import 'package:teacher_feat/domain/use_cases/get_teacher_list_use_case.dart';
import 'package:teacher_feat/injection_container.dart' as teacher_di;
import 'package:attendance/injection_container.dart' as attendance_di;
import 'package:attendance/domain/usecases/get_monthly_attendance_use_case.dart';
import 'package:attendance/domain/usecases/get_attendance_details_use_case.dart';

import 'features/ai_tutor/data/datasources/ai_tutor_remote_datasource.dart';
import 'features/ai_tutor/data/repositories/ai_tutor_repository_impl.dart';
import 'features/ai_tutor/domain/repositories/repositories.dart';
import 'features/ai_tutor/domain/use_cases/send_chat_message_use_case.dart';
import 'features/ai_tutor/presentation/bloc/tutor_chat_bloc.dart';
import 'features/authentication/presentation/blocs/auth_bloc.dart';
import 'features/dues/presentation/blocs/dues_bloc.dart';
import 'features/homework/presentation/blocs/home_work_bloc/homework_bloc.dart';
import 'features/homework/presentation/blocs/question_bloc/question_bloc.dart';
import 'features/notification/presintation/bloc/notification_bloc.dart';
import 'features/profile/presentation/bolcs/profile_bloc.dart';
import 'features/resource/presintation/blocs/resource_bloc.dart';
import 'features/subject/presentation/blocs/subject/subject_bloc.dart';
import 'features/subject/presentation/blocs/subject_list/subject_list_bloc.dart';
import 'features/teacher/presentation/blocs/teacher_list_bloc.dart';
import 'features/teacher/presentation/blocs/teacher_details_bloc.dart';
import 'features/atendance/presentation/blocs/attendance_bloc.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // استدعاء دوال الإعداد بالترتيب
  await core_di.setupCoreDependencies(getIt);
  await auth_di.setupAuthDependencies(getIt);
  await dues_di.setupDuesDependencies(getIt);
  await homework_di.setupHomeWorkDependencies(getIt);
  await notification_di.setupNotificationDependencies(getIt);
  await profile_di.setupProfileDependencies(getIt);
  await resource_di.setupResourceDependencies(getIt);
  await subject_di.setupSubjectDependencies(getIt);
  await teacher_di.setupTeacherFeatDependencies(getIt);
  await attendance_di.setupAttendanceDependencies(getIt);

  // AI Tutor dependencies
  getIt.registerLazySingleton<AITutorRemoteDataSource>(
    () => AITutorRemoteDataSourceImpl(),
  );
  getIt.registerLazySingleton<AITutorRepository>(
    () => AITutorRepositoryImpl(
      remoteDataSource: getIt<AITutorRemoteDataSource>(),
      networkInfo: getIt(),
    ),
  );
  getIt.registerLazySingleton<SendChatMessageUseCase>(
    () => SendChatMessageUseCase(getIt<AITutorRepository>()),
  );

  getIt.registerFactory(
    () => AuthBloc(
      checkAuthStatusUseCase: getIt<CheckAuthStatusUseCase>(),
      loginUseCase: getIt<LoginUseCase>(),
    ),
  );
  getIt.registerFactory(
    () => HomeworkBloc(getHomework: getIt<GetHomeworkUseCase>()),
  );
  getIt.registerFactory(
    () => QuestionBloc(
      getQuestionListUseCase: getIt<GetQuestionListUseCase>(),
      submitHomeworkUseCase: getIt<SubmitHomeworkUseCase>(),
    ),
  );
  getIt.registerFactory(
    () => DuesBloc(getMyDuesUseCase: getIt<GetMyDuesUseCase>()),
  );
  getIt.registerFactory(
    () => ProfileBloc(getUserProfileUseCase: getIt<GetUserProfileUseCase>()),
  );
  getIt.registerFactory(
    () => SubjectBloc(getSubjectUseCase: getIt<GetSubjectUseCase>()),
  );
  getIt.registerFactory(
    () => SubjectListBloc(
      getSubjectLListUseCase: getIt<GetSubjectLListUseCase>(),
    ),
  );
  getIt.registerFactory(
    () => NotificationBloc(
      getNotificationListUseCase: getIt<GetNotificationListUseCase>(),
    ),
  );
  getIt.registerFactory(
    () => ResourceBloc(getResourceListUseCase: getIt<GetResourceListUseCase>()),
  );
  getIt.registerFactory(
    () => ChatBloc(getGeminiResponse: getIt<SendChatMessageUseCase>()),
  );
  getIt.registerFactory(
    () => AttendanceBloc(
      getMonthlyAttendanceUseCase: getIt<GetMonthlyAttendanceUseCase>(),
      getAttendanceDetailsUseCase: getIt<GetAttendanceDetailsUseCase>(),
    ),
  );
  getIt.registerFactory(
    () => TeacherListBloc(teacherListUseCase: getIt<GetTeacherListUseCase>()),
  );
  getIt.registerFactory(
    () =>
        TeacherDetailsBloc(teacherByIdUseCase: getIt<GetTeacherByIdUseCase>()),
  );


}
