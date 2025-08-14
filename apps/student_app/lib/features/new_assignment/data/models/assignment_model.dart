import '../../domain/entities/assignment_entity.dart';

class AssignmentModel extends AssignmentEntity {
  AssignmentModel({
    required super.title,
    required super.description,
    required super.classId,
    required super.dueDate,
    required super.points,
    required super.assignmentId,
    required super.teacherAttachments,
    super.grade,
    super.submissionStatus,
    required super.createdAt,
  });

  factory AssignmentModel.fromJson(Map<String, dynamic> json) {
    return AssignmentModel(
      title: json['title'],
      description: json['description'],
      classId: json['classId'],
      dueDate: DateTime.parse(json['dueDate']),
      points: json['points'],
      assignmentId: json['assignmentId'],
      teacherAttachments: List<String>.from(json['teacherAttachments']),
      grade: json['grade'],
      submissionStatus: SubmissionStatus.values[json['submissionStatus']],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'classId': classId,
      'dueDate': dueDate.toIso8601String(),
      'points': points,
      'assignmentId': assignmentId,
      'teacherAttachments': teacherAttachments,
      'grade': grade,
      'submissionStatus': submissionStatus.index,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}