import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';
import '../entities/achievement.dart';
import '../entities/student.dart';

abstract class AchievementsRepository {
  Future<Either<Failure, List<Student>>> getStudents({
    String? searchQuery,
    String? classroom,
  });
  
  Future<Either<Failure, List<Achievement>>> getAvailableAchievements();
  
  Future<Either<Failure, List<Achievement>>> getStudentAchievements(String studentId);
  
  Future<Either<Failure, Unit>> grantAchievement({
    required String studentId,
    required String achievementId,
  });
  
  Future<Either<Failure, Unit>> revokeAchievement({
    required String studentId,
    required String achievementId,
  });
}
