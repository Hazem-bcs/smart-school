import '../entities/assignment_entity.dart';
import 'package:dartz/dartz.dart';

abstract class AssignmentRepository {
  Future<Either<Exception, List<AssignmentEntity>>> getAssignments(
    String classId,
  );
}
