abstract class AchievementsEvent {}

class LoadStudents extends AchievementsEvent {
  final String? searchQuery;
  final String? classroom;

  LoadStudents({this.searchQuery, this.classroom});
}

class LoadAvailableAchievements extends AchievementsEvent {
  LoadAvailableAchievements();
}

class LoadStudentAchievements extends AchievementsEvent {
  final String studentId;

  LoadStudentAchievements({required this.studentId});
}

class GrantAchievement extends AchievementsEvent {
  final String studentId;
  final String achievementId;

  GrantAchievement({
    required this.studentId,
    required this.achievementId,
  });
}

class RevokeAchievement extends AchievementsEvent {
  final String studentId;
  final String achievementId;

  RevokeAchievement({
    required this.studentId,
    required this.achievementId,
  });
}

class ClearError extends AchievementsEvent {
  ClearError();
}

class ResetState extends AchievementsEvent {
  ResetState();
}
