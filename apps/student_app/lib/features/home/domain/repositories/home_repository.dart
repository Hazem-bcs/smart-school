import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';
import '../entities/home_stats_entity.dart';
import '../entities/quick_action_entity.dart';
import '../entities/achievement_entity.dart';

abstract class HomeRepository {
  Future<Either<Failure, HomeStatsEntity>> getHomeStats();
  Future<Either<Failure, List<QuickActionEntity>>> getQuickActions();
  Future<Either<Failure, List<AchievementEntity>>> getAchievements();
}
