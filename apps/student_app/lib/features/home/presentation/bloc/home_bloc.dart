import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import '../../domain/entities/home_stats_entity.dart';
import '../../domain/entities/quick_action_entity.dart';
import '../../domain/entities/achievement_entity.dart';
import '../../domain/usecases/get_home_stats_usecase.dart';
import '../../domain/usecases/get_quick_actions_usecase.dart';
import '../../domain/usecases/get_achievements_usecase.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetHomeStatsUseCase getHomeStatsUseCase;
  final GetQuickActionsUseCase getQuickActionsUseCase;
  final GetAchievementsUseCase getAchievementsUseCase;

  HomeBloc({
    required this.getHomeStatsUseCase,
    required this.getQuickActionsUseCase,
    required this.getAchievementsUseCase,
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
      // Load all data concurrently
      final results = await Future.wait([
        getHomeStatsUseCase(),
        getQuickActionsUseCase(),
        getAchievementsUseCase(),
      ]);

      final statsResult = results[0] as Either<dynamic, HomeStatsEntity>;
      final actionsResult = results[1] as Either<dynamic, List<QuickActionEntity>>;
      final achievementsResult = results[2] as Either<dynamic, List<AchievementEntity>>;

      // Handle results using fold
      String errorMessage = '';
      HomeStatsEntity? stats;
      List<QuickActionEntity>? actions;
      List<AchievementEntity>? achievements;

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

      if (stats != null && actions != null && achievements != null) {
        emit(HomeLoaded(
          stats: stats!,
          quickActions: actions!,
          achievements: achievements!,
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
