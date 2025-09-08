class Student {
  final String id;
  final String name;
  final String classroom;
  final String avatarUrl;
  final List<String> unlockedAchievements;
  final int totalPoints;

  const Student({
    required this.id,
    required this.name,
    required this.classroom,
    required this.avatarUrl,
    this.unlockedAchievements = const [],
    this.totalPoints = 0,
  });

  // Alias for classroom to maintain compatibility
  String get className => classroom;

  Student copyWith({
    String? id,
    String? name,
    String? classroom,
    String? avatarUrl,
    List<String>? unlockedAchievements,
    int? totalPoints,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      classroom: classroom ?? this.classroom,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      unlockedAchievements: unlockedAchievements ?? this.unlockedAchievements,
      totalPoints: totalPoints ?? this.totalPoints,
    );
  }

  bool hasAchievement(String achievementId) {
    return unlockedAchievements.contains(achievementId);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Student &&
        other.id == id &&
        other.name == name &&
        other.classroom == classroom &&
        other.avatarUrl == avatarUrl &&
        other.unlockedAchievements == unlockedAchievements &&
        other.totalPoints == totalPoints;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        classroom.hashCode ^
        avatarUrl.hashCode ^
        unlockedAchievements.hashCode ^
        totalPoints.hashCode;
  }
}
