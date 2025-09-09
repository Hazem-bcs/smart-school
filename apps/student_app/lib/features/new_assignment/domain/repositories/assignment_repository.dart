import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';
import '../entities/assignment_entity.dart';

abstract class AssignmentRepository {
  Future<Either<Failure, List<AssignmentEntity>>> getAssignments(
    String classId,
  );

  Future<Either<Failure, Unit>> submitAssignment({
    required String assignmentId,
    required String studentId,
    required String answerText,
    String? imagePath,
  });
}
