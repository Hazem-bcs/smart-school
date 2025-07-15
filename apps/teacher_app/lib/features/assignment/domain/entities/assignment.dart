enum AssignmentStatus { graded, ungraded, all }

class Assignment {
  final String id;
  final String title;
  final String subtitle;
  final bool isCompleted;
  final DateTime dueDate;
  final int submittedCount;
  final int totalCount;
  final AssignmentStatus status;

  Assignment({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.isCompleted,
    required this.dueDate,
    required this.submittedCount,
    required this.totalCount,
    required this.status,
  });
} 