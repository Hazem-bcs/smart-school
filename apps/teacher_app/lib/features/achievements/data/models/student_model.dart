import '../../domain/entities/student.dart';

class StudentModel extends Student {
  const StudentModel({
    required super.id,
    required super.name,
    required super.classroom,
    required super.avatarUrl,
    super.unlockedAchievements = const [],
    super.totalPoints = 0,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'] as String,
      name: json['name'] as String,
      classroom: json['classroom'] as String,
      avatarUrl: json['avatar_url'] as String,
      unlockedAchievements: List<String>.from(json['unlocked_achievements'] ?? []),
      totalPoints: json['total_points'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'classroom': classroom,
      'avatar_url': avatarUrl,
      'unlocked_achievements': unlockedAchievements,
      'total_points': totalPoints,
    };
  }

  factory StudentModel.fromEntity(Student student) {
    return StudentModel(
      id: student.id,
      name: student.name,
      classroom: student.classroom,
      avatarUrl: student.avatarUrl,
      unlockedAchievements: student.unlockedAchievements,
      totalPoints: student.totalPoints,
    );
  }

  Student toEntity() {
    return Student(
      id: id,
      name: name,
      classroom: classroom,
      avatarUrl: avatarUrl,
      unlockedAchievements: unlockedAchievements,
      totalPoints: totalPoints,
    );
  }
}
