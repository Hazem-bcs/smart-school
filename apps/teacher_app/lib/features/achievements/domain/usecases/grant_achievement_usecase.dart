import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';
import '../repositories/achievements_repository.dart';

/// Use case لمنح إنجاز لطالب
class GrantAchievementUseCase {
  final AchievementsRepository _repository;

  GrantAchievementUseCase(this._repository);

  Future<Either<Failure, Unit>> call({
    required String studentId,
    required String achievementId,
  }) async {
    return await _repository.grantAchievement(
      studentId: studentId,
      achievementId: achievementId,
    );
  }
}

/// Use case لإلغاء إنجاز من طالب
class RevokeAchievementUseCase {
  final AchievementsRepository _repository;

  RevokeAchievementUseCase(this._repository);

  Future<Either<Failure, Unit>> call({
    required String studentId,
    required String achievementId,
  }) async {
    return await _repository.revokeAchievement(
      studentId: studentId,
      achievementId: achievementId,
    );
  }
}
