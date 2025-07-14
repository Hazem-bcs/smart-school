import '../entities/submission.dart';

abstract class SubmissionRepository {
  Future<Submission> getSubmission(String id);
  Future<void> submitGrade(String submissionId, String grade, String feedback);
  Future<List<Submission>> getSubmissionsForAssignment(String assignmentId);
} 