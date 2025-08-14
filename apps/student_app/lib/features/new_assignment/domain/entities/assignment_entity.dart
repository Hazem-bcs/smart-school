enum SubmissionStatus {
  notSubmitted,
  graded,
}

class AssignmentEntity {
  final String title;
  final String description;
  final String classId;
  final DateTime dueDate;
  final int points;
  final String assignmentId;
  final List<String> teacherAttachments;
  final int? grade;
  final SubmissionStatus submissionStatus;
  final DateTime createdAt;

  AssignmentEntity({
    required this.title,
    required this.description,
    required this.classId,
    required this.dueDate,
    required this.points,
    required this.assignmentId,
    required this.teacherAttachments,
    this.grade,
    this.submissionStatus = SubmissionStatus.notSubmitted,
    required this.createdAt,
  });
}