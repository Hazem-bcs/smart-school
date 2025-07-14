class AssignmentModel {
  final String id;
  final String title;
  final String subtitle;
  final DateTime dueDate;
  final String status;

  const AssignmentModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.dueDate,
    required this.status,
  });

  factory AssignmentModel.fromJson(Map<String, dynamic> json) {
    return AssignmentModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      dueDate: DateTime.parse(json['dueDate'] ?? DateTime.now().toIso8601String()),
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'dueDate': dueDate.toIso8601String(),
      'status': status,
    };
  }
} 