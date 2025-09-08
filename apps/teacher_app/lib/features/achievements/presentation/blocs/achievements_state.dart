import '../../domain/entities/achievement.dart';
import '../../domain/entities/student.dart';

abstract class AchievementsState {}

class AchievementsInitial extends AchievementsState {}

class AchievementsLoading extends AchievementsState {
  final List<Achievement>? availableAchievements;

  AchievementsLoading({this.availableAchievements});
}

class StudentsLoaded extends AchievementsState {
  final List<Student> students;
  final List<Student>? filteredStudents;

  StudentsLoaded({required this.students, this.filteredStudents});
  
  List<Student> get displayStudents => filteredStudents ?? students;
}

class AvailableAchievementsLoaded extends AchievementsState {
  final List<Achievement> achievements;

  AvailableAchievementsLoaded({required this.achievements});
}

class StudentAchievementsLoaded extends AchievementsState {
  final List<Achievement> achievements;
  final List<Achievement>? availableAchievements;
  final String studentId;

  StudentAchievementsLoaded({
    required this.achievements,
    this.availableAchievements,
    required this.studentId,
  });
}

class AchievementGranted extends AchievementsState {
  final String message;
  final String studentId;
  final String achievementId;
  final List<Achievement>? availableAchievements;

  AchievementGranted({
    required this.message,
    required this.studentId,
    required this.achievementId,
    this.availableAchievements,
  });
}

class AchievementRevoked extends AchievementsState {
  final String message;
  final String studentId;
  final String achievementId;
  final List<Achievement>? availableAchievements;

  AchievementRevoked({
    required this.message,
    required this.studentId,
    required this.achievementId,
    this.availableAchievements,
  });
}

class AchievementsError extends AchievementsState {
  final String message;

  AchievementsError({required this.message});
}
