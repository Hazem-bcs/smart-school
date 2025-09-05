import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';
import '../../domain/entities/student_submission.dart';
import '../../domain/repositories/submission_repository.dart';
import '../data_sources/submission_remote_data_source.dart';

class SubmissionRepositoryImpl implements SubmissionRepository {
  final SubmissionRemoteDataSource remoteDataSource;

  SubmissionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<StudentSubmission>>> getStudentSubmissions() async {
    final result = await remoteDataSource.getStudentSubmissions();
    return result.fold(
      (failure) => Left(failure),
      (models) => Right(models
          .map(
            (m) => StudentSubmission(
              id: m.id,
              studentName: m.studentName,
              response: m.response,
              images: m.images,
              grade: m.grade,
              feedback: m.feedback,
              submittedAt: m.submittedAt,
              isGraded: m.isGraded,
            ),
          )
          .toList()),
    );
  }

  @override
  Future<Either<Failure, bool>> submitGrade(String submissionId, String grade, String feedback) {
    return remoteDataSource.submitGrade(submissionId, grade, feedback);
  }

  @override
  Future<Either<Failure, bool>> markAssignmentAsGraded(String assignmentId) {
    return remoteDataSource.markAssignmentAsGraded(assignmentId);
  }
} 