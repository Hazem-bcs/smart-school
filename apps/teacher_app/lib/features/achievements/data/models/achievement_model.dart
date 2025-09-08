import '../../domain/entities/achievement.dart';

class AchievementModel extends Achievement {
  const AchievementModel({
    required super.id,
    required super.title,
    required super.description,
    required super.iconPath,
    required super.isUnlocked,
    required super.points,
    super.unlockedAt,
  });

  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      iconPath: json['icon_path'] as String,
      isUnlocked: json['is_unlocked'] as bool,
      points: json['points'] as int,
      unlockedAt: json['unlocked_at'] != null 
          ? DateTime.parse(json['unlocked_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon_path': iconPath,
      'is_unlocked': isUnlocked,
      'points': points,
      'unlocked_at': unlockedAt?.toIso8601String(),
    };
  }

  factory AchievementModel.fromEntity(Achievement achievement) {
    return AchievementModel(
      id: achievement.id,
      title: achievement.title,
      description: achievement.description,
      iconPath: achievement.iconPath,
      isUnlocked: achievement.isUnlocked,
      points: achievement.points,
      unlockedAt: achievement.unlockedAt,
    );
  }

  Achievement toEntity() {
    return Achievement(
      id: id,
      title: title,
      description: description,
      iconPath: iconPath,
      isUnlocked: isUnlocked,
      points: points,
      unlockedAt: unlockedAt,
    );
  }
}
