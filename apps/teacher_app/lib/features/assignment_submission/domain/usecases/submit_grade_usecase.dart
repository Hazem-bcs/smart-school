import '../repositories/submission_repository.dart';

class SubmitGradeUseCase {
  final SubmissionRepository repository;

  SubmitGradeUseCase(this.repository);

  Future<void> call(String submissionId, String grade, String feedback) async {
    await repository.submitGrade(submissionId, grade, feedback);
  }
} 