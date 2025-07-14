class AssignmentEntity {
  final String id;
  final String title;
  final String subtitle;
  final DateTime dueDate;
  final String status;

  const AssignmentEntity({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.dueDate,
    required this.status,
  });
} 