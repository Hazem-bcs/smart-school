class ResourceEntity {
  final String id;
  final String title;
  final String description;
  final String url;
  final String teacherId;
  final List<String> targetClasses;
  final DateTime createdAt;

  ResourceEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.url,
    required this.teacherId,
    this.targetClasses = const [],
    required this.createdAt,
  });
}