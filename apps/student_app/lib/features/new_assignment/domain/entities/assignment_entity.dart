import 'package:equatable/equatable.dart';

enum SubmissionStatus { notSubmitted, submitted, graded }

class AssignmentEntity extends Equatable {
  final String assignmentId;
  final String title;
  final String description;
  final String classId;
  final DateTime dueDate;
  final int points;
  final SubmissionStatus submissionStatus;
  final int? grade;
  final String? teacherNote;
  final DateTime createdAt;

  final String? teacherImageAttachment;

  const AssignmentEntity({
    required this.assignmentId,
    required this.title,
    required this.description,
    required this.classId,
    required this.dueDate,
    required this.points,
    this.submissionStatus = SubmissionStatus.notSubmitted,
    this.grade,
    this.teacherNote,
    required this.createdAt,

    this.teacherImageAttachment,
  });

  // Method to create a copy of the object with some changed properties
  AssignmentEntity copyWith({
    String? assignmentId,
    String? title,
    String? description,
    String? classId,
    DateTime? dueDate,
    int? points,
    SubmissionStatus? submissionStatus,
    int? grade,
    String? teacherNote,
    DateTime? createdAt,
    String? teacherImageAttachment,
  }) {
    return AssignmentEntity(
      assignmentId: assignmentId ?? this.assignmentId,
      title: title ?? this.title,
      description: description ?? this.description,
      classId: classId ?? this.classId,
      dueDate: dueDate ?? this.dueDate,
      points: points ?? this.points,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      grade: grade ?? this.grade,
      teacherNote: teacherNote ?? this.teacherNote,
      createdAt: createdAt ?? this.createdAt,
      teacherImageAttachment:
          teacherImageAttachment ?? this.teacherImageAttachment,
    );
  }

  @override
  List<Object?> get props => [
    assignmentId,
    title,
    description,
    classId,
    dueDate,
    points,
    submissionStatus,
    grade,
    teacherNote,
    createdAt,

    teacherImageAttachment,
  ];
}
