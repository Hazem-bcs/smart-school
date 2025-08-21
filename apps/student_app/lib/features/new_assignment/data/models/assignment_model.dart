import '../../domain/entities/assignment_entity.dart';

class AssignmentModel extends AssignmentEntity {
  const AssignmentModel({
    required super.assignmentId,
    required super.title,
    required super.description,
    required super.classId,
    required super.dueDate,
    required super.points,
    super.submissionStatus,
    super.grade,
    super.teacherNote,
    required super.createdAt,

    super.teacherImageAttachment,
  });

  factory AssignmentModel.fromJson(Map<String, dynamic> json) {
    return AssignmentModel(
      assignmentId: json['assignmentId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      classId: json['classId'] as String,
      dueDate: DateTime.parse(json['dueDate'] as String),
      points: json['points'] as int,
      submissionStatus:
          SubmissionStatus.values[json['submissionStatus'] as int],
      grade: json['grade'] as int?,
      teacherNote: json['teacherNote'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      teacherImageAttachment: json['teacherImageAttachment'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'assignmentId': assignmentId,
      'title': title,
      'description': description,
      'classId': classId,
      'dueDate': dueDate.toIso8601String(),
      'points': points,
      'submissionStatus': submissionStatus.index,
      'grade': grade,
      'teacherNote': teacherNote,
      'createdAt': createdAt.toIso8601String(),

      'teacherImageAttachment': teacherImageAttachment,
    };
  }
}
