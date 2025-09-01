part of 'home_bloc.dart';

abstract class HomeState {
  const HomeState();
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final HomeStatsEntity stats;
  final List<QuickActionEntity> quickActions;
  final List<AchievementEntity> achievements;
  final List<PromoEntity> promos;

  const HomeLoaded({
    required this.stats,
    required this.quickActions,
    required this.achievements,
    required this.promos,
  });
}

class HomeError extends HomeState {
  final String message;

  const HomeError({required this.message});
}
