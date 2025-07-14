import 'package:equatable/equatable.dart';

abstract class SubmissionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Load submission data
class LoadSubmissionData extends SubmissionEvent {
  final String assignmentId;
  
  LoadSubmissionData(this.assignmentId);
  
  @override
  List<Object?> get props => [assignmentId];
}

// Submit grade
class SubmitGrade extends SubmissionEvent {
  final String submissionId;
  final String grade;
  final String feedback;
  
  SubmitGrade({
    required this.submissionId,
    required this.grade,
    required this.feedback,
  });
  
  @override
  List<Object?> get props => [submissionId, grade, feedback];
}

// Navigate to next student
class NavigateToNextStudent extends SubmissionEvent {}

// Navigate to previous student
class NavigateToPreviousStudent extends SubmissionEvent {}

// Navigate to specific student
class NavigateToStudent extends SubmissionEvent {
  final int studentIndex;
  
  NavigateToStudent(this.studentIndex);
  
  @override
  List<Object?> get props => [studentIndex];
}

// Refresh submission data
class RefreshSubmissionData extends SubmissionEvent {} 