import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_students_usecase.dart';
import '../../domain/usecases/get_achievements_usecase.dart';
import '../../domain/usecases/grant_achievement_usecase.dart';
import 'achievements_event.dart';
import 'achievements_state.dart';

/// BLoC لإدارة حالة الإنجازات والطلاب
class AchievementsBloc extends Bloc<AchievementsEvent, AchievementsState> {
  final GetStudentsUseCase _getStudentsUseCase;
  final GetAvailableAchievementsUseCase _getAvailableAchievementsUseCase;
  final GetStudentAchievementsUseCase _getStudentAchievementsUseCase;
  final GrantAchievementUseCase _grantAchievementUseCase;
  final RevokeAchievementUseCase _revokeAchievementUseCase;

  AchievementsBloc({
    required GetStudentsUseCase getStudentsUseCase,
    required GetAvailableAchievementsUseCase getAvailableAchievementsUseCase,
    required GetStudentAchievementsUseCase getStudentAchievementsUseCase,
    required GrantAchievementUseCase grantAchievementUseCase,
    required RevokeAchievementUseCase revokeAchievementUseCase,
  }) : _getStudentsUseCase = getStudentsUseCase,
       _getAvailableAchievementsUseCase = getAvailableAchievementsUseCase,
       _getStudentAchievementsUseCase = getStudentAchievementsUseCase,
       _grantAchievementUseCase = grantAchievementUseCase,
       _revokeAchievementUseCase = revokeAchievementUseCase,
       super(AchievementsInitial()) {
    on<LoadStudents>(_onLoadStudents);
    on<LoadAvailableAchievements>(_onLoadAvailableAchievements);
    on<LoadStudentAchievements>(_onLoadStudentAchievements);
    on<GrantAchievement>(_onGrantAchievement);
    on<RevokeAchievement>(_onRevokeAchievement);
    on<ClearError>(_onClearError);
    on<ResetState>(_onResetState);
  }

  Future<void> _onLoadStudents(
    LoadStudents event,
    Emitter<AchievementsState> emit,
  ) async {
    emit(AchievementsLoading());
    
    final result = await _getStudentsUseCase(
      searchQuery: event.searchQuery,
      classroom: event.classroom,
    );
    
    result.fold(
      (failure) => emit(AchievementsError(message: failure.message)),
      (students) => emit(StudentsLoaded(students: students)),
    );
  }

  Future<void> _onLoadAvailableAchievements(
    LoadAvailableAchievements event,
    Emitter<AchievementsState> emit,
  ) async {
    emit(AchievementsLoading());
    
    final result = await _getAvailableAchievementsUseCase();
    
    result.fold(
      (failure) => emit(AchievementsError(message: failure.message)),
      (achievements) => emit(AvailableAchievementsLoaded(achievements: achievements)),
    );
  }

  Future<void> _onLoadStudentAchievements(
    LoadStudentAchievements event,
    Emitter<AchievementsState> emit,
  ) async {
    emit(AchievementsLoading());
    
    final result = await _getStudentAchievementsUseCase(event.studentId);
    
    result.fold(
      (failure) => emit(AchievementsError(message: failure.message)),
      (achievements) => emit(StudentAchievementsLoaded(
        achievements: achievements,
        studentId: event.studentId,
      )),
    );
  }

  Future<void> _onGrantAchievement(
    GrantAchievement event,
    Emitter<AchievementsState> emit,
  ) async {
    emit(AchievementsLoading());
    
    final result = await _grantAchievementUseCase(
      studentId: event.studentId,
      achievementId: event.achievementId,
    );
    
    result.fold(
      (failure) => emit(AchievementsError(message: failure.message)),
      (_) => emit(AchievementGranted(
        message: 'تم منح الإنجاز بنجاح!',
        studentId: event.studentId,
        achievementId: event.achievementId,
      )),
    );
  }

  Future<void> _onRevokeAchievement(
    RevokeAchievement event,
    Emitter<AchievementsState> emit,
  ) async {
    emit(AchievementsLoading());
    
    final result = await _revokeAchievementUseCase(
      studentId: event.studentId,
      achievementId: event.achievementId,
    );
    
    result.fold(
      (failure) => emit(AchievementsError(message: failure.message)),
      (_) => emit(AchievementRevoked(
        message: 'تم إلغاء الإنجاز بنجاح!',
        studentId: event.studentId,
        achievementId: event.achievementId,
      )),
    );
  }

  void _onClearError(
    ClearError event,
    Emitter<AchievementsState> emit,
  ) {
    if (state is AchievementsError) {
      emit(AchievementsInitial());
    }
  }

  void _onResetState(
    ResetState event,
    Emitter<AchievementsState> emit,
  ) {
    emit(AchievementsInitial());
  }
}
