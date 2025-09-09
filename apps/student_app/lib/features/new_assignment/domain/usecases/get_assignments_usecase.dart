import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';
import '../entities/assignment_entity.dart';
import '../repositories/assignment_repository.dart';

class GetAssignmentsUseCase {
  final AssignmentRepository repository;

  GetAssignmentsUseCase(this.repository);

  Future<Either<Failure, List<AssignmentEntity>>> call(String classId) async {
    return await repository.getAssignments(classId);
  }
}