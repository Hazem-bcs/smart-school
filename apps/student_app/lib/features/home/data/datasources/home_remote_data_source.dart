import 'dart:convert';
import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';
import '../models/home_stats_model.dart';
import '../models/quick_action_model.dart';
import '../models/achievement_model.dart';

abstract class HomeRemoteDataSource {
  Future<Either<Failure, HomeStatsModel>> getHomeStats();
  Future<Either<Failure, List<QuickActionModel>>> getQuickActions();
  Future<Either<Failure, List<AchievementModel>>> getAchievements();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  @override
  Future<Either<Failure, HomeStatsModel>> getHomeStats() async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Simulate random failures (10% chance)
      if (DateTime.now().millisecondsSinceEpoch % 10 == 0) {
        return const Left(ServerFailure(message: 'فشل في الاتصال بالخادم'));
      }

      // Fake JSON data
      const String fakeJson = '''
      {
        "attendance_percentage": 95.5,
        "completed_assignments": 18,
        "total_assignments": 22,
        "average_score": 87.3,
        "current_rank": 3,
        "total_students": 35,
        "unread_notifications": 5,
        "upcoming_quizzes": 2,
        "homework_completion_rate": 81.8,
        "streak_days": 12
      }
      ''';

      final Map<String, dynamic> jsonData = json.decode(fakeJson);
      return Right(HomeStatsModel.fromJson(jsonData));
    } catch (e) {
      return Left(ServerFailure(message: 'خطأ في معالجة البيانات: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<QuickActionModel>>> getQuickActions() async {
    try {
      await Future.delayed(const Duration(milliseconds: 600));
      
      if (DateTime.now().millisecondsSinceEpoch % 15 == 0) {
        return const Left(ServerFailure(message: 'فشل في تحميل الإجراءات السريعة'));
      }

      const String fakeJson = '''
      [
        {
          "id": "1",
          "title": "الواجبات",
          "subtitle": "3 واجبات جديدة",
          "icon_path": "assets/svg/homework.svg",
          "route": "/assignments",
          "count": 3,
          "is_active": true
        },
        {
          "id": "2",
          "title": "الحضور",
          "subtitle": "متابعة الحضور",
          "icon_path": "assets/svg/attendance.svg",
          "route": "/attendancePage",
          "count": 0,
          "is_active": true
        },
        {
          "id": "3",
          "title": "الاختبارات",
          "subtitle": "2 اختبار قادم",
          "icon_path": "assets/svg/quiz.svg",
          "route": "/homeWorkPage",
          "count": 2,
          "is_active": true
        },
        {
          "id": "4",
          "title": "الموارد",
          "subtitle": "ملفات تعليمية",
          "icon_path": "assets/svg/media.svg",
          "route": "/resourcesPage",
          "count": 8,
          "is_active": true
        }
      ]
      ''';

      final List<dynamic> jsonList = json.decode(fakeJson);
      final List<QuickActionModel> actions = jsonList
          .map((json) => QuickActionModel.fromJson(json))
          .toList();
      
      return Right(actions);
    } catch (e) {
      return Left(ServerFailure(message: 'خطأ في تحميل الإجراءات السريعة: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<AchievementModel>>> getAchievements() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (DateTime.now().millisecondsSinceEpoch % 20 == 0) {
        return const Left(ServerFailure(message: 'فشل في تحميل الإنجازات'));
      }

      const String fakeJson = '''
      [
        {
          "id": "1",
          "title": "طالب مجتهد",
          "description": "أكمل 10 واجبات متتالية",
          "icon_path": "assets/svg/achievement1.svg",
          "is_unlocked": true,
          "points": 100,
          "unlocked_at": "2024-01-15T10:30:00Z"
        },
        {
          "id": "2",
          "title": "حضور مثالي",
          "description": "حضر 20 يوم متتالي",
          "icon_path": "assets/svg/achievement2.svg",
          "is_unlocked": true,
          "points": 150,
          "unlocked_at": "2024-01-20T08:15:00Z"
        },
        {
          "id": "3",
          "title": "متفوق دراسي",
          "description": "حصل على 95% في الاختبار",
          "icon_path": "assets/svg/achievement3.svg",
          "is_unlocked": false,
          "points": 200,
          "unlocked_at": null
        },
        {
          "id": "4",
          "title": "قارئ نشط",
          "description": "اقرأ 5 موارد تعليمية",
          "icon_path": "assets/svg/achievement4.svg",
          "is_unlocked": false,
          "points": 75,
          "unlocked_at": null
        }
      ]
      ''';

      final List<dynamic> jsonList = json.decode(fakeJson);
      final List<AchievementModel> achievements = jsonList
          .map((json) => AchievementModel.fromJson(json))
          .toList();
      
      return Right(achievements);
    } catch (e) {
      return Left(ServerFailure(message: 'خطأ في تحميل الإنجازات: ${e.toString()}'));
    }
  }
}
