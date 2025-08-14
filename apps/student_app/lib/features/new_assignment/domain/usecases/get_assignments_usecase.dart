import '../entities/assignment_entity.dart';
import '../repositories/assignment_repository.dart';
import 'package:dartz/dartz.dart';

class GetAssignmentsUseCase {
  final AssignmentRepository repository;

  GetAssignmentsUseCase(this.repository);

  Future<Either<Exception, List<AssignmentEntity>>> call(String classId) async {
    return await repository.getAssignments(classId);
  }
}