import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';
import '../repositories/home_repository.dart';
import '../entities/achievement_entity.dart';

class GetAchievementsUseCase {
  final HomeRepository repository;

  GetAchievementsUseCase(this.repository);

  Future<Either<Failure, List<AchievementEntity>>> call() async {
    return await repository.getAchievements();
  }
}
