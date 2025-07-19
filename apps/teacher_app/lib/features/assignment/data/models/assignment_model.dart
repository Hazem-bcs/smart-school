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
        id: json['id']?.toString() ?? '',
        title: json['title']?.toString() ?? '',
        subtitle: json['subtitle']?.toString() ?? '',
        isCompleted: json['isCompleted'] as bool? ?? false,
        dueDate: DateTime.parse(json['dueDate']?.toString() ?? DateTime.now().toIso8601String()),
        submittedCount: json['submittedCount'] as int? ?? 0,
        totalCount: json['totalCount'] as int? ?? 0,
        status: _parseAssignmentStatus(json['status']?.toString() ?? 'ungraded'),
      );
  }

  static AssignmentStatus _parseAssignmentStatus(String status) {
    switch (status.toLowerCase()) {
      case 'graded':
        return AssignmentStatus.graded;
      case 'ungraded':
        return AssignmentStatus.ungraded;
      case 'all':
        return AssignmentStatus.all;
      default:
        return AssignmentStatus.ungraded;
    }
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