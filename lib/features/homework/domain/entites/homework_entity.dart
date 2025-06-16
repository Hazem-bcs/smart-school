class HomeworkEntity {
  final String id;
  final String title;
  final String subject;
  final DateTime assignedDate;
  final DateTime dueDate;
  final String status; // في الـ Entity، من الأفضل استخدام String أو int للحالة

  HomeworkEntity({
    required this.id,
    required this.title,
    required this.subject,
    required this.assignedDate,
    required this.dueDate,
    required this.status,
  });
}