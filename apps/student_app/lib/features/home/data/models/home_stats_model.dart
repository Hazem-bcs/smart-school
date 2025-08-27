import '../../domain/entities/home_stats_entity.dart';

class HomeStatsModel extends HomeStatsEntity {
  const HomeStatsModel({
    required super.attendancePercentage,
    required super.completedAssignments,
    required super.totalAssignments,
    required super.averageScore,
    required super.currentRank,
    required super.totalStudents,
    required super.unreadNotifications,
    required super.upcomingQuizzes,
    required super.homeworkCompletionRate,
    required super.streakDays,
  });

  factory HomeStatsModel.fromJson(Map<String, dynamic> json) {
    return HomeStatsModel(
      attendancePercentage: (json['attendance_percentage'] as num).toDouble(),
      completedAssignments: json['completed_assignments'] as int,
      totalAssignments: json['total_assignments'] as int,
      averageScore: (json['average_score'] as num).toDouble(),
      currentRank: json['current_rank'] as int,
      totalStudents: json['total_students'] as int,
      unreadNotifications: json['unread_notifications'] as int,
      upcomingQuizzes: json['upcoming_quizzes'] as int,
      homeworkCompletionRate: (json['homework_completion_rate'] as num).toDouble(),
      streakDays: json['streak_days'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attendance_percentage': attendancePercentage,
      'completed_assignments': completedAssignments,
      'total_assignments': totalAssignments,
      'average_score': averageScore,
      'current_rank': currentRank,
      'total_students': totalStudents,
      'unread_notifications': unreadNotifications,
      'upcoming_quizzes': upcomingQuizzes,
      'homework_completion_rate': homeworkCompletionRate,
      'streak_days': streakDays,
    };
  }
}
