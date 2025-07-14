import '../../domain/entities/submission.dart';
import '../../domain/entities/assignment.dart';
import '../../domain/entities/student.dart';

class SubmissionRemoteDataSource {
  // Fake in-memory data
  final List<Submission> _submissions = [
    Submission(
      id: '1',
      assignment: Assignment(id: 'a1', title: 'Math Homework', description: 'Solve all exercises.'),
      student: Student(id: 's1', name: 'Ali Ahmed', avatarUrl: ''),
      response: 'Response 1',
      imageUrls: [],
      submittedAt: DateTime.now().subtract(const Duration(days: 1)),
      grade: '90',
      feedback: 'Good job',
    ),
    Submission(
      id: '2',
      assignment: Assignment(id: 'a1', title: 'Math Homework', description: 'Solve all exercises.'),
      student: Student(id: 's2', name: 'Sara Mohamed', avatarUrl: ''),
      response: 'Response 2',
      imageUrls: [],
      submittedAt: DateTime.now().subtract(const Duration(days: 2)),
      grade: null,
      feedback: null,
    ),
  ];

  Future<Submission> getSubmission(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _submissions.firstWhere((s) => s.id == id);
  }

  Future<void> submitGrade(String submissionId, String grade, String feedback) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _submissions.indexWhere((s) => s.id == submissionId);
    if (index != -1) {
      final old = _submissions[index];
      _submissions[index] = Submission(
        id: old.id,
        assignment: old.assignment,
        student: old.student,
        response: old.response,
        imageUrls: old.imageUrls,
        submittedAt: old.submittedAt,
        grade: grade,
        feedback: feedback,
      );
    }
  }

  Future<List<Submission>> getSubmissionsForAssignment(String assignmentId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Return all for mock
    return _submissions.where((s) => s.assignment.id == assignmentId).toList();
  }
} 