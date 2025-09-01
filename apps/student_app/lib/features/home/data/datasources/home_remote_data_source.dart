import 'dart:convert';
import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';
import '../models/home_stats_model.dart';
import '../models/quick_action_model.dart';
import '../models/achievement_model.dart';
import '../models/promo_model.dart';

abstract class HomeRemoteDataSource {
  Future<Either<Failure, HomeStatsModel>> getHomeStats();
  Future<Either<Failure, List<QuickActionModel>>> getQuickActions();
  Future<Either<Failure, List<AchievementModel>>> getAchievements();
  Future<Either<Failure, List<PromoModel>>> getPromos();
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

  @override
  Future<Either<Failure, List<PromoModel>>> getPromos() async {
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      
      if (DateTime.now().millisecondsSinceEpoch % 25 == 0) {
        return const Left(ServerFailure(message: 'فشل في تحميل الإعلانات'));
      }

      const String fakeJson = '''
      [
        {
          "id": "1",
          "title": "إعلان مهم",
          "subtitle": "اضغط لمعرفة المزيد",
          "image_url": "https://plus.unsplash.com/premium_photo-1680807869780-e0876a6f3cd5?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8c2Nob29sfGVufDB8fDB8fHww",
          "description": "إعلان مهم للطلاب حول الجدول الدراسي الجديد",
          "is_active": true,
          "start_date": "2024-01-01T00:00:00Z",
          "end_date": "2024-12-31T23:59:59Z",
          "priority": 1
        },
        {
          "id": "2",
          "title": "فعالية مدرسية",
          "subtitle": "انضم إلينا",
          "image_url": "https://images.unsplash.com/photo-1573706376056-55f27105ff17?q=80&w=1171&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
          "description": "فعالية مدرسية مميزة للطلاب",
          "is_active": true,
          "start_date": "2024-01-01T00:00:00Z",
          "end_date": "2024-12-31T23:59:59Z",
          "priority": 2
        },
        {
          "id": "3",
          "title": "مكتبة المدرسة",
          "subtitle": "اكتشف الكتب الجديدة",
          "image_url": "https://images.unsplash.com/photo-1580974852861-c381510bc98a?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTV8fHNjaG9vbHxlbnwwfHwwfHx8MA%3D%3D",
          "description": "مكتبة المدرسة تفتح أبوابها للطلاب",
          "is_active": true,
          "start_date": "2024-01-01T00:00:00Z",
          "end_date": "2024-12-31T23:59:59Z",
          "priority": 3
        },
        {
          "id": "4",
          "title": "نادي العلوم",
          "subtitle": "انضم إلى فريق البحث",
          "image_url": "https://plus.unsplash.com/premium_photo-1671070290623-d6f76bdbb3db?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTd8fHNjaG9vbHxlbnwwfHwwfHx8MA%3D%3D",
          "description": "نادي العلوم يفتح أبوابه للطلاب المهتمين",
          "is_active": true,
          "start_date": "2024-01-01T00:00:00Z",
          "end_date": "2024-12-31T23:59:59Z",
          "priority": 4
        },
        {
          "id": "5",
          "title": "مختبر الحاسوب",
          "subtitle": "تعلم البرمجة",
          "image_url": "https://images.unsplash.com/photo-1601780313063-ab9174e43dcc?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MzJ8fCVEOSU4NCVEOCVCNyVEOSU4NCVEOCVBNyVEOCVBOCUyMCVEOCVBNyVEOSU4NCVEOSU4NSVEOCVBRiVEOCVBNyVEOCVCMSVEOCVCMyUyMCVEOCVBQSVEOCVBRCVEOSU4MSVEOSU4QSVEOCVCMiUyMCVEOCVCOSVEOCVBOCVEOCVBNyVEOCVCMSVEOCVBNyVEOCVBQXxlbnwwfHwwfHx8MA%3D%3D",
          "description": "مختبر الحاسوب متاح للطلاب",
          "is_active": true,
          "start_date": "2024-01-01T00:00:00Z",
          "end_date": "2024-12-31T23:59:59Z",
          "priority": 5
        },
        {
          "id": "6",
          "title": "ملعب المدرسة",
          "subtitle": "مارس الرياضة",
          "image_url": "https://plus.unsplash.com/premium_photo-1735775899897-278b39a81679?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MzN8fCVEOSU4NCVEOCVCNyVEOSU4NCVEOCVBNyVEOCVBOCUyMCVEOCVBNyVEOSU4NCVEOSU4NSVEOCVBRiVEOCVBNyVEOCVCMSVEOCVCMyUyMCVEOCVBQSVEOCVBRCVEOSU4MSVEOSU4QSVEOCVCMiUyMCVEOCVCOSVEOCVBOCVEOCVBNyVEOCVCMSVEOCVBNyVEOCVBQXxlbnwwfHwwfHx8MA%3D%3D",
          "description": "ملعب المدرسة متاح للطلاب",
          "is_active": true,
          "start_date": "2024-01-01T00:00:00Z",
          "end_date": "2024-12-31T23:59:59Z",
          "priority": 6
        }
      ]
      ''';

      final List<dynamic> jsonList = json.decode(fakeJson);
      final List<PromoModel> promos = jsonList
          .map((json) => PromoModel.fromJson(json))
          .toList();
      
      return Right(promos);
    } catch (e) {
      return Left(ServerFailure(message: 'خطأ في تحميل الإعلانات: ${e.toString()}'));
    }
  }
}