import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';
import '../../domain/entities/achievement.dart';
import '../../domain/entities/student.dart';
import '../../domain/repositories/achievements_repository.dart';
import '../data_sources/achievements_remote_data_source.dart';

class AchievementsRepositoryImpl implements AchievementsRepository {
  final AchievementsRemoteDataSource remoteDataSource;

  AchievementsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Student>>> getStudents({
    String? searchQuery,
    String? classroom,
  }) async {
    final result = await remoteDataSource.getStudents(
      searchQuery: searchQuery,
      classroom: classroom,
    );
    
    return result.fold(
      (failure) => Left(failure),
      (studentModels) => Right(studentModels.map((model) => model.toEntity()).toList()),
    );
  }

  @override
  Future<Either<Failure, List<Achievement>>> getAvailableAchievements() async {
    final result = await remoteDataSource.getAvailableAchievements();
    
    return result.fold(
      (failure) => Left(failure),
      (achievementModels) => Right(achievementModels.map((model) => model.toEntity()).toList()),
    );
  }

  @override
  Future<Either<Failure, List<Achievement>>> getStudentAchievements(String studentId) async {
    final result = await remoteDataSource.getStudentAchievements(studentId);
    
    return result.fold(
      (failure) => Left(failure),
      (achievementModels) => Right(achievementModels.map((model) => model.toEntity()).toList()),
    );
  }

  @override
  Future<Either<Failure, Unit>> grantAchievement({
    required String studentId,
    required String achievementId,
  }) async {
    return await remoteDataSource.grantAchievement(
      studentId: studentId,
      achievementId: achievementId,
    );
  }

  @override
  Future<Either<Failure, Unit>> revokeAchievement({
    required String studentId,
    required String achievementId,
  }) async {
    return await remoteDataSource.revokeAchievement(
      studentId: studentId,
      achievementId: achievementId,
    );
  }
}
