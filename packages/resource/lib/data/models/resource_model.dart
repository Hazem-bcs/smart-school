import '../../domain/entities/resource_entity.dart';

class ResourceModel {
  final String id;
  final String title;
  final String description;
  final String url;
  final String teacherId;
  final List<String> targetClasses;
  final DateTime createdAt;

  ResourceModel({
    required this.id,
    required this.title,
    required this.description,
    required this.url,
    required this.teacherId,
    this.targetClasses = const [],
    required this.createdAt,
  });

  factory ResourceModel.fromJson(Map<String, dynamic> json) {
    return ResourceModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      url: json['url'],
      teacherId: json['teacherId'],
      createdAt: json['createdAt'],
    );
  }

  ResourceEntity toEntity() {
    return ResourceEntity(
      id: id,
      title: title,
      description: description,
      url: url,
      teacherId: teacherId,
      createdAt: createdAt,
    );
  }
}
