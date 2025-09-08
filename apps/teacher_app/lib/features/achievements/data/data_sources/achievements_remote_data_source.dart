import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';
import 'package:core/network/dio_client.dart';
import '../models/achievement_model.dart';
import '../models/student_model.dart';

abstract class AchievementsRemoteDataSource {
  Future<Either<Failure, List<StudentModel>>> getStudents({
    String? searchQuery,
    String? classroom,
  });
  
  Future<Either<Failure, List<AchievementModel>>> getAvailableAchievements();
  
  Future<Either<Failure, List<AchievementModel>>> getStudentAchievements(String studentId);
  
  Future<Either<Failure, Unit>> grantAchievement({
    required String studentId,
    required String achievementId,
  });
  
  Future<Either<Failure, Unit>> revokeAchievement({
    required String studentId,
    required String achievementId,
  });
}

class AchievementsRemoteDataSourceImpl implements AchievementsRemoteDataSource {
  final DioClient dioClient;

  AchievementsRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<Either<Failure, List<StudentModel>>> getStudents({
    String? searchQuery,
    String? classroom,
  }) async {
    try {
      // *****
      // API وهمي - جلب قائمة الطلاب
      // *****
      await Future.delayed(const Duration(milliseconds: 800));
      
      final mockResponse = {
        "data": [
          {
            "id": "1",
            "name": "أحمد محمد",
            "classroom": "أ/1",
            "avatar_url": "https://via.placeholder.com/150/4CAF50/white?text=أ",
            "unlocked_achievements": ["1", "2"],
            "total_points": 250
          },
          {
            "id": "2",
            "name": "فاطمة علي",
            "classroom": "أ/1",
            "avatar_url": "https://via.placeholder.com/150/2196F3/white?text=ف",
            "unlocked_achievements": ["1"],
            "total_points": 100
          },
          {
            "id": "3",
            "name": "محمد حسن",
            "classroom": "أ/2",
            "avatar_url": "https://via.placeholder.com/150/FF9800/white?text=م",
            "unlocked_achievements": ["1", "2", "3"],
            "total_points": 450
          },
          {
            "id": "4",
            "name": "سارة أحمد",
            "classroom": "أ/2",
            "avatar_url": "https://via.placeholder.com/150/E91E63/white?text=س",
            "unlocked_achievements": [],
            "total_points": 0
          },
          {
            "id": "5",
            "name": "علي محمود",
            "classroom": "أ/3",
            "avatar_url": "https://via.placeholder.com/150/9C27B0/white?text=ع",
            "unlocked_achievements": ["2", "4"],
            "total_points": 225
          },
          {
            "id": "6",
            "name": "نور الدين",
            "classroom": "أ/3",
            "avatar_url": "https://via.placeholder.com/150/607D8B/white?text=ن",
            "unlocked_achievements": ["1", "3", "4"],
            "total_points": 375
          },
        ],
        "message": "تم جلب قائمة الطلاب بنجاح",
        "status": 200
      };
      
      if (mockResponse["status"] != 200) {
        return Left(ServerFailure(message: (mockResponse["message"] as String?) ?? "حدث خطأ في جلب الطلاب"));
      }
      
      // *****
      // كتلة DioClient معلقة - الاستدعاء الحقيقي
      // *****
      /*
      final response = await dioClient.get(
        '/students',
        queryParameters: {
          if (searchQuery != null && searchQuery.isNotEmpty) 'search': searchQuery,
          if (classroom != null && classroom.isNotEmpty) 'classroom': classroom,
        },
      );
      
      if (response.statusCode != 200) {
        return Left(ServerFailure(
          message: response.data['message'] ?? 'حدث خطأ في جلب الطلاب'
        ));
      }
      
      final students = (response.data['data'] as List)
          .map((json) => StudentModel.fromJson(json as Map<String, dynamic>))
          .toList();
      
      return Right(students);
      */
      
      List<Map<String, dynamic>> studentsData = List<Map<String, dynamic>>.from(mockResponse["data"] as List);

      // Apply search filter
      if (searchQuery != null && searchQuery.isNotEmpty) {
        studentsData = studentsData
            .where((student) => student['name'].toString().contains(searchQuery))
            .toList();
      }

      // Apply classroom filter
      if (classroom != null && classroom.isNotEmpty) {
        studentsData = studentsData
            .where((student) => student['classroom'] == classroom)
            .toList();
      }

      final students = studentsData
          .map((json) => StudentModel.fromJson(json))
          .toList();

      return Right(students);
    } catch (e) {
      return Left(ServerFailure(message: "حدث خطأ في جلب الطلاب"));
    }
  }

  @override
  Future<Either<Failure, List<AchievementModel>>> getAvailableAchievements() async {
    try {
      // *****
      // API وهمي - جلب الإنجازات المتاحة
      // *****
      await Future.delayed(const Duration(milliseconds: 600));
      
      final mockResponse = {
        "data": [
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
          },
          {
            "id": "5",
            "title": "مشارك نشط",
            "description": "شارك في 5 مناقشات صفية",
            "icon_path": "assets/svg/achievement5.svg",
            "is_unlocked": false,
            "points": 120,
            "unlocked_at": null
          },
          {
            "id": "6",
            "title": "قائد فريق",
            "description": "قاد مشروع جماعي بنجاح",
            "icon_path": "assets/svg/achievement6.svg",
            "is_unlocked": false,
            "points": 300,
            "unlocked_at": null
          }
        ],
        "message": "تم جلب الإنجازات المتاحة بنجاح",
        "status": 200
      };
      
      if (mockResponse["status"] != 200) {
        return Left(ServerFailure(message: (mockResponse["message"] as String?) ?? "حدث خطأ في جلب الإنجازات"));
      }
      
      // *****
      // كتلة DioClient معلقة - الاستدعاء الحقيقي
      // *****
      /*
      final response = await dioClient.get('/achievements');
      
      if (response.statusCode != 200) {
        return Left(ServerFailure(
          message: response.data['message'] ?? 'حدث خطأ في جلب الإنجازات'
        ));
      }
      
      final achievements = (response.data['data'] as List)
          .map((json) => AchievementModel.fromJson(json as Map<String, dynamic>))
          .toList();
      
      return Right(achievements);
      */
      
      final achievements = (mockResponse["data"] as List)
          .map((json) => AchievementModel.fromJson(json as Map<String, dynamic>))
          .toList();

      return Right(achievements);
    } catch (e) {
      return Left(ServerFailure(message: "حدث خطأ في جلب الإنجازات"));
    }
  }

  @override
  Future<Either<Failure, List<AchievementModel>>> getStudentAchievements(String studentId) async {
    try {
      // *****
      // API وهمي - جلب إنجازات طالب محدد
      // *****
      await Future.delayed(const Duration(milliseconds: 500));
      
      final mockResponse = {
        "data": [
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
          },
          {
            "id": "5",
            "title": "مشارك نشط",
            "description": "شارك في 5 مناقشات صفية",
            "icon_path": "assets/svg/achievement5.svg",
            "is_unlocked": false,
            "points": 120,
            "unlocked_at": null
          },
          {
            "id": "6",
            "title": "قائد فريق",
            "description": "قاد مشروع جماعي بنجاح",
            "icon_path": "assets/svg/achievement6.svg",
            "is_unlocked": false,
            "points": 300,
            "unlocked_at": null
          }
        ],
        "message": "تم جلب إنجازات الطالب بنجاح",
        "status": 200
      };
      
      if (mockResponse["status"] != 200) {
        return Left(ServerFailure(message: (mockResponse["message"] as String?) ?? "حدث خطأ في جلب إنجازات الطالب"));
      }
      
      // *****
      // كتلة DioClient معلقة - الاستدعاء الحقيقي
      // *****
      /*
      final response = await dioClient.get('/students/$studentId/achievements');
      
      if (response.statusCode != 200) {
        return Left(ServerFailure(
          message: response.data['message'] ?? 'حدث خطأ في جلب إنجازات الطالب'
        ));
      }
      
      final achievements = (response.data['data'] as List)
          .map((json) => AchievementModel.fromJson(json as Map<String, dynamic>))
          .toList();
      
      return Right(achievements);
      */
      
      final achievements = (mockResponse["data"] as List)
          .map((json) => AchievementModel.fromJson(json as Map<String, dynamic>))
          .toList();

      return Right(achievements);
    } catch (e) {
      return Left(ServerFailure(message: "حدث خطأ في جلب إنجازات الطالب"));
    }
  }

  @override
  Future<Either<Failure, Unit>> grantAchievement({
    required String studentId,
    required String achievementId,
  }) async {
    try {
      // *****
      // API وهمي - منح إنجاز للطالب
      // *****
      await Future.delayed(const Duration(milliseconds: 800));
      
      // محاكاة استجابة API
      final mockResponse = {
        "data": {
          "student_id": studentId,
          "achievement_id": achievementId,
          "granted_at": DateTime.now().toIso8601String(),
        },
        "message": "تم منح الإنجاز بنجاح",
        "status": 200
      };
      
      if (mockResponse["status"] != 200) {
        return Left(ServerFailure(message: (mockResponse["message"] as String?) ?? "حدث خطأ في منح الإنجاز"));
      }
      
      // *****
      // كتلة DioClient معلقة - الاستدعاء الحقيقي
      // *****
      /*
      final response = await dioClient.post(
        '/achievements/grant',
        data: {
          'student_id': studentId,
          'achievement_id': achievementId,
        },
      );
      
      if (response.statusCode != 200) {
        return Left(ServerFailure(
          message: response.data['message'] ?? 'حدث خطأ في منح الإنجاز'
        ));
      }
      
      return const Right(unit);
      */
      
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(message: "حدث خطأ في منح الإنجاز"));
    }
  }

  @override
  Future<Either<Failure, Unit>> revokeAchievement({
    required String studentId,
    required String achievementId,
  }) async {
    try {
      // *****
      // API وهمي - إلغاء إنجاز من الطالب
      // *****
      await Future.delayed(const Duration(milliseconds: 800));
      
      // محاكاة استجابة API
      final mockResponse = {
        "data": {
          "student_id": studentId,
          "achievement_id": achievementId,
          "revoked_at": DateTime.now().toIso8601String(),
        },
        "message": "تم إلغاء الإنجاز بنجاح",
        "status": 200
      };
      
      if (mockResponse["status"] != 200) {
        return Left(ServerFailure(message: (mockResponse["message"] as String?) ?? "حدث خطأ في إلغاء الإنجاز"));
      }
      
      // *****
      // كتلة DioClient معلقة - الاستدعاء الحقيقي
      // *****
      /*
      final response = await dioClient.delete(
        '/achievements/revoke',
        data: {
          'student_id': studentId,
          'achievement_id': achievementId,
        },
      );
      
      if (response.statusCode != 200) {
        return Left(ServerFailure(
          message: response.data['message'] ?? 'حدث خطأ في إلغاء الإنجاز'
        ));
      }
      
      return const Right(unit);
      */
      
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(message: "حدث خطأ في إلغاء الإنجاز"));
    }
  }
}
