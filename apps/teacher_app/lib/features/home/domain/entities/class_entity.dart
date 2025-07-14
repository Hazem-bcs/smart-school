class ClassEntity {
  final String id;
  final String title;
  final String imageUrl;
  final int studentCount;
  final String subject;

  const ClassEntity({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.studentCount = 0,
    required this.subject,
  });
} 