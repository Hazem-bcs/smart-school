import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';
import 'package:teacher_app/features/home/domain/usecases/get_assignments_usecase.dart';
import '../../domain/usecases/get_classes_usecase.dart';

import '../../domain/usecases/get_notifications_usecase.dart';
import 'home_event.dart';
import 'home_state.dart';
import '../../domain/entities/class_entity.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/entities/assignment_entity.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetHomeClassesUseCase getClassesUseCase;
  final GetAssignmentsUseCase getAssignmentsUseCase;
  final GetNotificationsUseCase getNotificationsUseCase;

  HomeBloc({
    required this.getClassesUseCase,
    required this.getAssignmentsUseCase,
    required this.getNotificationsUseCase,
  }) : super(HomeInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<RefreshHomeData>(_onRefreshHomeData);
  }

  Future<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());

    final Either<Failure, List<ClassEntity>> classesResult = await getClassesUseCase();
    final Either<Failure, List<AssignmentEntity>> assignmentsResult = await getAssignmentsUseCase();
    final Either<Failure, List<NotificationEntity>> notificationsResult = await getNotificationsUseCase();

    if (classesResult.isLeft()) {
      emit(HomeError(classesResult.swap().getOrElse(() => const UnknownFailure(message: 'خطأ غير متوقع')).message));
      return;
    }
    if (assignmentsResult.isLeft()) {
      emit(HomeError(assignmentsResult.swap().getOrElse(() => const UnknownFailure(message: 'خطأ غير متوقع')).message));
      return;
    }
    if (notificationsResult.isLeft()) {
      emit(HomeError(notificationsResult.swap().getOrElse(() => const UnknownFailure(message: 'خطأ غير متوقع')).message));
      return;
    }

    final classes = classesResult.getOrElse(() => const <ClassEntity>[]);
    final assignments = assignmentsResult.getOrElse(() => const <AssignmentEntity>[]);
    final notifications = notificationsResult.getOrElse(() => const <NotificationEntity>[]);

    emit(HomeLoaded(
      classes: classes,
      assignments: assignments,
      notifications: notifications,
    ));
  }

  Future<void> _onRefreshHomeData(
    RefreshHomeData event,
    Emitter<HomeState> emit,
  ) async {
    final Either<Failure, List<ClassEntity>> classesResult = await getClassesUseCase();
    final Either<Failure, List<AssignmentEntity>> assignmentsResult = await getAssignmentsUseCase();
    final Either<Failure, List<NotificationEntity>> notificationsResult = await getNotificationsUseCase();

    if (classesResult.isLeft()) {
      emit(HomeError(classesResult.swap().getOrElse(() => const UnknownFailure(message: 'خطأ غير متوقع')).message));
      return;
    }
    if (assignmentsResult.isLeft()) {
      emit(HomeError(assignmentsResult.swap().getOrElse(() => const UnknownFailure(message: 'خطأ غير متوقع')).message));
      return;
    }
    if (notificationsResult.isLeft()) {
      emit(HomeError(notificationsResult.swap().getOrElse(() => const UnknownFailure(message: 'خطأ غير متوقع')).message));
      return;
    }

    final classes = classesResult.getOrElse(() => const <ClassEntity>[]);
    final assignments = assignmentsResult.getOrElse(() => const <AssignmentEntity>[]);
    final notifications = notificationsResult.getOrElse(() => const <NotificationEntity>[]);

    emit(HomeLoaded(
      classes: classes,
      assignments: assignments,
      notifications: notifications,
    ));
  }
} 