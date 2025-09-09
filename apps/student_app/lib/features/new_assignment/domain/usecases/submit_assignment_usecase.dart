import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';
import '../repositories/assignment_repository.dart';

class SubmitAssignmentUseCase {
  final AssignmentRepository repository;

  SubmitAssignmentUseCase(this.repository);

  Future<Either<Failure, Unit>> call({
    required String assignmentId,
    required String studentId,
    required String answerText,
    String? imagePath,
  }) async {
    return repository.submitAssignment(
      assignmentId: assignmentId,
      studentId: studentId,
      answerText: answerText,
      imagePath: imagePath,
    );
  }
}


