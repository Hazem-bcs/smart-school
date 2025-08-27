import 'package:equatable/equatable.dart';

class HomeStatsEntity extends Equatable {
  final double attendancePercentage;
  final int completedAssignments;
  final int totalAssignments;
  final double averageScore;
  final int currentRank;
  final int totalStudents;
  final int unreadNotifications;
  final int upcomingQuizzes;
  final double homeworkCompletionRate;
  final int streakDays;

  const HomeStatsEntity({
    required this.attendancePercentage,
    required this.completedAssignments,
    required this.totalAssignments,
    required this.averageScore,
    required this.currentRank,
    required this.totalStudents,
    required this.unreadNotifications,
    required this.upcomingQuizzes,
    required this.homeworkCompletionRate,
    required this.streakDays,
  });

  double get assignmentCompletionRate => 
      totalAssignments > 0 ? (completedAssignments / totalAssignments) * 100 : 0;

  @override
  List<Object?> get props => [
        attendancePercentage,
        completedAssignments,
        totalAssignments,
        averageScore,
        currentRank,
        totalStudents,
        unreadNotifications,
        upcomingQuizzes,
        homeworkCompletionRate,
        streakDays,
      ];
}
