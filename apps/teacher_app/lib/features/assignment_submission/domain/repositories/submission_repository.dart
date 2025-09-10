import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';
import '../entities/student_submission.dart';

abstract class SubmissionRepository {
  Future<Either<Failure, List<StudentSubmission>>> getStudentSubmissions(String assignmentId);
  Future<Either<Failure, bool>> submitGrade(String submissionId, String grade, String feedback);
  Future<Either<Failure, bool>> markAssignmentAsGraded(String assignmentId);
} 