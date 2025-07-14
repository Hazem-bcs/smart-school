class AssignmentModel {
  final String id;
  final String title;
  final String description;

  AssignmentModel({
    required this.id,
    required this.title,
    required this.description,
  });

  factory AssignmentModel.fromJson(Map<String, dynamic> json) {
    return AssignmentModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }
} 