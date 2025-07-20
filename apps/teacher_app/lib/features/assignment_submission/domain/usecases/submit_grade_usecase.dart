import '../repositories/submission_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';

class SubmitGradeUseCase {
  final SubmissionRepository repository;

  SubmitGradeUseCase(this.repository);

  Future<Either<Failure, bool>> call(String submissionId, String grade, String feedback) {
    return repository.submitGrade(submissionId, grade, feedback);
  }
} 