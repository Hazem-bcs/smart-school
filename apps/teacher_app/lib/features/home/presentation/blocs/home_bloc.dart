import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_app/features/home/domain/usecases/get_assignments_usecase.dart';
import '../../domain/usecases/get_classes_usecase.dart';

import '../../domain/usecases/get_notifications_usecase.dart';
import 'home_event.dart';
import 'home_state.dart';

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
    
    try {
      final classes = await getClassesUseCase();
      final notifications = await getNotificationsUseCase();
      emit(HomeLoaded(
        classes: classes,
        assignments: [],
        notifications: notifications,
      ));
    } catch (e) {
      emit(HomeError('Failed to load home data: $e'));
    }
  }

  Future<void> _onRefreshHomeData(
    RefreshHomeData event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final classes = await getClassesUseCase();
      final notifications = await getNotificationsUseCase();
      emit(HomeLoaded(
        classes: classes,
        assignments: [],
        notifications: notifications,
      ));
    } catch (e) {
      emit(HomeError('Failed to refresh home data: $e'));
    }
  }
} 