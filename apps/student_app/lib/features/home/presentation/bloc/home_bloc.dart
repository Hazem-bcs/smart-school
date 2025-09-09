import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import '../../domain/entities/home_stats_entity.dart';
import '../../domain/entities/quick_action_entity.dart';
import '../../domain/entities/achievement_entity.dart';
import '../../domain/entities/promo_entity.dart';
import '../../domain/entities/attendance_trend_entity.dart';
import '../../domain/usecases/get_home_stats_usecase.dart';
import '../../domain/usecases/get_quick_actions_usecase.dart';
import '../../domain/usecases/get_achievements_usecase.dart';
import '../../domain/usecases/get_promos_usecase.dart';
import '../../domain/usecases/get_attendance_trend_usecase.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetHomeStatsUseCase getHomeStatsUseCase;
  final GetQuickActionsUseCase getQuickActionsUseCase;
  final GetAchievementsUseCase getAchievementsUseCase;
  final GetPromosUseCase getPromosUseCase;
  final GetAttendanceTrendUseCase getAttendanceTrendUseCase;

  HomeBloc({
    required this.getHomeStatsUseCase,
    required this.getQuickActionsUseCase,
    required this.getAchievementsUseCase,
    required this.getPromosUseCase,
    required this.getAttendanceTrendUseCase,
  }) : super(HomeInitial()) {
    on<LoadHomeDataEvent>(_onLoadHomeData);
    on<RefreshHomeDataEvent>(_onRefreshHomeData);
  }

  Future<void> _onLoadHomeData(
    LoadHomeDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    
    try {
      final startDate = DateTime.now().subtract(const Duration(days: 6));

      // Load all data concurrently
      final results = await Future.wait([
        getHomeStatsUseCase(),
        getQuickActionsUseCase(),
        getAchievementsUseCase(),
        getPromosUseCase(),
        getAttendanceTrendUseCase(startDate),
      ]);

      final statsResult = results[0] as Either<dynamic, HomeStatsEntity>;
      final actionsResult = results[1] as Either<dynamic, List<QuickActionEntity>>;
      final achievementsResult = results[2] as Either<dynamic, List<AchievementEntity>>;
      final promosResult = results[3] as Either<dynamic, List<PromoEntity>>;
      final trendResult = results[4] as Either<dynamic, AttendanceTrendEntity>;

      // Handle results using fold
      String errorMessage = '';
      HomeStatsEntity? stats;
      List<QuickActionEntity>? actions;
      List<AchievementEntity>? achievements;
      List<PromoEntity>? promos;
      AttendanceTrendEntity? attendanceTrend;

      statsResult.fold(
        (failure) => errorMessage += '${failure.message}\n',
        (success) => stats = success,
      );

      actionsResult.fold(
        (failure) => errorMessage += '${failure.message}\n',
        (success) => actions = success,
      );

      achievementsResult.fold(
        (failure) => errorMessage += '${failure.message}\n',
        (success) => achievements = success,
      );

      promosResult.fold(
        (failure) => errorMessage += '${failure.message}\n',
        (success) => promos = success,
      );

      trendResult.fold(
        (failure) => errorMessage += '${failure.message}\n',
        (success) => attendanceTrend = success,
      );

      if (stats != null && actions != null && achievements != null && promos != null && attendanceTrend != null) {
        emit(HomeLoaded(
          stats: stats!,
          quickActions: actions!,
          achievements: achievements!,
          promos: promos!,
          attendanceTrend: attendanceTrend!,
        ));
      } else {
        emit(HomeError(message: errorMessage.trim()));
      }
    } catch (e) {
      emit(HomeError(message: 'حدث خطأ غير متوقع: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshHomeData(
    RefreshHomeDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    add(LoadHomeDataEvent());
  }
}
