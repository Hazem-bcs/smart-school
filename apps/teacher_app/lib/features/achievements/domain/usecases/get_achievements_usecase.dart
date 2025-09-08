import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';
import '../entities/achievement.dart';
import '../repositories/achievements_repository.dart';

/// Use case لجلب جميع الإنجازات المتاحة
class GetAvailableAchievementsUseCase {
  final AchievementsRepository _repository;

  GetAvailableAchievementsUseCase(this._repository);

  Future<Either<Failure, List<Achievement>>> call() async {
    return await _repository.getAvailableAchievements();
  }
}

/// Use case لجلب إنجازات طالب محدد
class GetStudentAchievementsUseCase {
  final AchievementsRepository _repository;

  GetStudentAchievementsUseCase(this._repository);

  Future<Either<Failure, List<Achievement>>> call(String studentId) async {
    return await _repository.getStudentAchievements(studentId);
  }
}
