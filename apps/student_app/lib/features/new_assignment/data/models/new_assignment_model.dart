class NewAssignmentModel {
  final String title;
  final String description;
  final String classId;
  final DateTime dueDate;
  final int points;

  NewAssignmentModel({
    required this.title,
    required this.description,
    required this.classId,
    required this.dueDate,
    required this.points,
  });

  factory NewAssignmentModel.fromJson(Map<String, dynamic> json) {
    return NewAssignmentModel(
      title: json['title'],
      description: json['description'],
      classId: json['classId'],
      dueDate: DateTime.parse(json['dueDate']),
      points: json['points'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'classId': classId,
      'dueDate': dueDate.toIso8601String(),
      'points': points,
    };
  }
} 