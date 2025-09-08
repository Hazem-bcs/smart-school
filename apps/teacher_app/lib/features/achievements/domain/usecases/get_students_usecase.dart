import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';
import '../entities/student.dart';
import '../repositories/achievements_repository.dart';

/// Use case لجلب قائمة الطلاب مع إمكانية البحث والتصفية
class GetStudentsUseCase {
  final AchievementsRepository _repository;

  GetStudentsUseCase(this._repository);

  Future<Either<Failure, List<Student>>> call({
    String? searchQuery,
    String? classroom,
  }) async {
    return await _repository.getStudents(
      searchQuery: searchQuery,
      classroom: classroom,
    );
  }
}
