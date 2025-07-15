import '../../domain/entities/assignment.dart';

class AssignmentModel extends Assignment {
  AssignmentModel({
    required super.id,
    required super.title,
    required super.subtitle,
    required super.isCompleted,
    required super.dueDate,
    required super.submittedCount,
    required super.totalCount,
    required super.status,
  });

  factory AssignmentModel.fromJson(Map<String, dynamic> json) {
    return AssignmentModel(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      isCompleted: json['isCompleted'] as bool,
      dueDate: DateTime.parse(json['dueDate'] as String),
      submittedCount: json['submittedCount'] as int,
      totalCount: json['totalCount'] as int,
      status: AssignmentStatus.values.firstWhere(
        (e) => e.toString() == 'AssignmentStatus.' + (json['status'] as String),
        orElse: () => AssignmentStatus.ungraded,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'isCompleted': isCompleted,
      'dueDate': dueDate.toIso8601String(),
      'submittedCount': submittedCount,
      'totalCount': totalCount,
      'status': status.toString().split('.').last,
    };
  }

  factory AssignmentModel.fromEntity(Assignment entity) {
    return AssignmentModel(
      id: entity.id,
      title: entity.title,
      subtitle: entity.subtitle,
      isCompleted: entity.isCompleted,
      dueDate: entity.dueDate,
      submittedCount: entity.submittedCount,
      totalCount: entity.totalCount,
      status: entity.status,
    );
  }

  Assignment toEntity() => this;
} 