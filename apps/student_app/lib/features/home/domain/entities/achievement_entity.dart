import 'package:equatable/equatable.dart';

class AchievementEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String iconPath;
  final bool isUnlocked;
  final int points;
  final DateTime? unlockedAt;

  const AchievementEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.iconPath,
    required this.isUnlocked,
    required this.points,
    this.unlockedAt,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        iconPath,
        isUnlocked,
        points,
        unlockedAt,
      ];
}
