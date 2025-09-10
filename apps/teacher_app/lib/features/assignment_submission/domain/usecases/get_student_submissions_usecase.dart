import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';
import '../entities/student_submission.dart';
import '../repositories/submission_repository.dart';

class GetStudentSubmissionsUseCase {
  final SubmissionRepository repository;
  GetStudentSubmissionsUseCase(this.repository);

  Future<Either<Failure, List<StudentSubmission>>> call(String assignmentId) {
    return repository.getStudentSubmissions(assignmentId);
  }
} 