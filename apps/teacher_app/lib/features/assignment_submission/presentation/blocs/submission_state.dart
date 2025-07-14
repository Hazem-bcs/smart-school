import 'package:equatable/equatable.dart';

abstract class SubmissionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubmissionIdle extends SubmissionState {}

class SubmissionLoading extends SubmissionState {}

class SubmissionSuccess extends SubmissionState {}

class SubmissionError extends SubmissionState {
  final String message;
  
  SubmissionError(this.message);
  
  @override
  List<Object?> get props => [message];
}

class SubmissionDataLoaded extends SubmissionState {
  final List<StudentSubmission> students;
  final int currentStudentIndex;
  final bool hasNextStudent;
  final bool hasPreviousStudent;
  
  SubmissionDataLoaded({
    required this.students,
    required this.currentStudentIndex,
    required this.hasNextStudent,
    required this.hasPreviousStudent,
  });
  
  @override
  List<Object?> get props => [students, currentStudentIndex, hasNextStudent, hasPreviousStudent];
}

// Mock data model for student submission
class StudentSubmission {
  final String id;
  final String studentName;
  final String response;
  final List<String> images;
  final String? grade;
  final String? feedback;
  final DateTime submittedAt;
  final bool isGraded;
  
  StudentSubmission({
    required this.id,
    required this.studentName,
    required this.response,
    required this.images,
    this.grade,
    this.feedback,
    required this.submittedAt,
    required this.isGraded,
  });
} 