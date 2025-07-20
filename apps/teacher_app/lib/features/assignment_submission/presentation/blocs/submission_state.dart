import 'package:equatable/equatable.dart';
import '../../domain/entities/student_submission.dart';

abstract class SubmissionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubmissionIdle extends SubmissionState {}

class SubmissionLoading extends SubmissionState {}

class SubmissionSuccess extends SubmissionState {
  final String? message;
  SubmissionSuccess({this.message});

  @override
  List<Object?> get props => [message];
}

class SubmissionError extends SubmissionState {
  final String message;
  final bool canRetry;
  final String? retryAction;
  
  SubmissionError(this.message, {this.canRetry = false, this.retryAction});
  
  @override
  List<Object?> get props => [message, canRetry, retryAction];
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

class SubmissionLoadError extends SubmissionState {
  final String message;
  final String assignmentId;
  
  SubmissionLoadError(this.message, this.assignmentId);
  
  @override
  List<Object?> get props => [message, assignmentId];
}

class GradeSubmissionError extends SubmissionState {
  final String message;
  final String submissionId;
  final String grade;
  final String feedback;
  final List<StudentSubmission> students;
  final int currentStudentIndex;
  final bool hasNextStudent;
  final bool hasPreviousStudent;
  
  GradeSubmissionError({
    required this.message,
    required this.submissionId,
    required this.grade,
    required this.feedback,
    required this.students,
    required this.currentStudentIndex,
    required this.hasNextStudent,
    required this.hasPreviousStudent,
  });
  
  @override
  List<Object?> get props => [message, submissionId, grade, feedback, students, currentStudentIndex, hasNextStudent, hasPreviousStudent];
}

class MarkAsGradedError extends SubmissionState {
  final String message;
  final String assignmentId;
  final List<StudentSubmission> students;
  final int currentStudentIndex;
  final bool hasNextStudent;
  final bool hasPreviousStudent;
  
  MarkAsGradedError({
    required this.message,
    required this.assignmentId,
    required this.students,
    required this.currentStudentIndex,
    required this.hasNextStudent,
    required this.hasPreviousStudent,
  });
  
  @override
  List<Object?> get props => [message, assignmentId, students, currentStudentIndex, hasNextStudent, hasPreviousStudent];
} 