import 'package:equatable/equatable.dart';

class StudentSubmission extends Equatable {
  final String id;
  final String studentName;
  final String response;
  final List<String> images;
  final String? grade;
  final String? feedback;
  final DateTime submittedAt;
  final bool isGraded;

  const StudentSubmission({
    required this.id,
    required this.studentName,
    required this.response,
    required this.images,
    this.grade,
    this.feedback,
    required this.submittedAt,
    required this.isGraded,
  });

  @override
  List<Object?> get props => [id, studentName, response, images, grade, feedback, submittedAt, isGraded];
} 