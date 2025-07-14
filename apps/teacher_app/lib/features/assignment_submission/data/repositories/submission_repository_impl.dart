import '../../domain/repositories/submission_repository.dart';
import '../../domain/entities/submission.dart';
import '../data_sources/submission_remote_data_source.dart';

class SubmissionRepositoryImpl implements SubmissionRepository {
  final SubmissionRemoteDataSource remoteDataSource;

  SubmissionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Submission> getSubmission(String id) {
    return remoteDataSource.getSubmission(id);
  }

  @override
  Future<void> submitGrade(String submissionId, String grade, String feedback) {
    return remoteDataSource.submitGrade(submissionId, grade, feedback);
  }

  @override
  Future<List<Submission>> getSubmissionsForAssignment(String assignmentId) {
    return remoteDataSource.getSubmissionsForAssignment(assignmentId);
  }
} 