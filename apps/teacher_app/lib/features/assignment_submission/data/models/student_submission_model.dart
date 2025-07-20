import '../../domain/entities/student_submission.dart';

class StudentSubmissionModel {
  final String id;
  final String studentName;
  final String response;
  final List<String> images;
  final String? grade;
  final String? feedback;
  final DateTime submittedAt;
  final bool isGraded;

  const StudentSubmissionModel({
    required this.id,
    required this.studentName,
    required this.response,
    required this.images,
    this.grade,
    this.feedback,
    required this.submittedAt,
    required this.isGraded,
  });

  factory StudentSubmissionModel.fromJson(Map<String, dynamic> json) {
    return StudentSubmissionModel(
      id: json['id'] as String,
      studentName: json['studentName'] as String,
      response: json['response'] as String,
      images: List<String>.from(json['images'] as List),
      grade: json['grade'] as String?,
      feedback: json['feedback'] as String?,
      submittedAt: DateTime.parse(json['submittedAt'] as String),
      isGraded: json['isGraded'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'studentName': studentName,
        'response': response,
        'images': images,
        'grade': grade,
        'feedback': feedback,
        'submittedAt': submittedAt.toIso8601String(),
        'isGraded': isGraded,
      };

  StudentSubmission toEntity() => StudentSubmission(
        id: id,
        studentName: studentName,
        response: response,
        images: images,
        grade: grade,
        feedback: feedback,
        submittedAt: submittedAt,
        isGraded: isGraded,
      );

  factory StudentSubmissionModel.fromEntity(StudentSubmission entity) => StudentSubmissionModel(
        id: entity.id,
        studentName: entity.studentName,
        response: entity.response,
        images: entity.images,
        grade: entity.grade,
        feedback: entity.feedback,
        submittedAt: entity.submittedAt,
        isGraded: entity.isGraded,
      );
} 