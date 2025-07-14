import 'assignment_model.dart';
import 'student_model.dart';

class SubmissionModel {
  final String id;
  final AssignmentModel assignment;
  final StudentModel student;
  final String response;
  final List<String> imageUrls;
  final DateTime submittedAt;
  final String? grade;
  final String? feedback;

  SubmissionModel({
    required this.id,
    required this.assignment,
    required this.student,
    required this.response,
    required this.imageUrls,
    required this.submittedAt,
    this.grade,
    this.feedback,
  });

  factory SubmissionModel.fromJson(Map<String, dynamic> json) {
    return SubmissionModel(
      id: json['id'] as String,
      assignment: AssignmentModel.fromJson(json['assignment'] as Map<String, dynamic>),
      student: StudentModel.fromJson(json['student'] as Map<String, dynamic>),
      response: json['response'] as String,
      imageUrls: List<String>.from(json['imageUrls'] as List),
      submittedAt: DateTime.parse(json['submittedAt'] as String),
      grade: json['grade'] as String?,
      feedback: json['feedback'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'assignment': assignment.toJson(),
      'student': student.toJson(),
      'response': response,
      'imageUrls': imageUrls,
      'submittedAt': submittedAt.toIso8601String(),
      'grade': grade,
      'feedback': feedback,
    };
  }
} 