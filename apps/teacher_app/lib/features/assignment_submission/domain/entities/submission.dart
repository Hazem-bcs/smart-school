import 'assignment.dart';
import 'student.dart';

class Submission {
  final String id;
  final Assignment assignment;
  final Student student;
  final String response;
  final List<String> imageUrls;
  final DateTime submittedAt;
  final String? grade;
  final String? feedback;

  Submission({
    required this.id,
    required this.assignment,
    required this.student,
    required this.response,
    required this.imageUrls,
    required this.submittedAt,
    this.grade,
    this.feedback,
  });
} 