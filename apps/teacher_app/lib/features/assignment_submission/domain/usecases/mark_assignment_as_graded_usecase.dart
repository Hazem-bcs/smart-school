import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';
import '../repositories/submission_repository.dart';

class MarkAssignmentAsGradedUseCase {
  final SubmissionRepository repository;
  MarkAssignmentAsGradedUseCase(this.repository);

  Future<Either<Failure, bool>> call(String assignmentId) {
    return repository.markAssignmentAsGraded(assignmentId);
  }
} 