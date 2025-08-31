import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';
import '../../domain/repositories/home_repository.dart';
import '../../domain/entities/home_stats_entity.dart';
import '../../domain/entities/quick_action_entity.dart';
import '../../domain/entities/achievement_entity.dart';
import '../../domain/entities/promo_entity.dart';
import '../datasources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, HomeStatsEntity>> getHomeStats() async {
    return await remoteDataSource.getHomeStats();
  }

  @override
  Future<Either<Failure, List<QuickActionEntity>>> getQuickActions() async {
    return await remoteDataSource.getQuickActions();
  }

  @override
  Future<Either<Failure, List<AchievementEntity>>> getAchievements() async {
    return await remoteDataSource.getAchievements();
  }

  @override
  Future<Either<Failure, List<PromoEntity>>> getPromos() async {
    return await remoteDataSource.getPromos();
  }
}
