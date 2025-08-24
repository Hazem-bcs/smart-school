import 'package:core/network/dio_client.dart';
import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';

import '../models/resource_model.dart';

abstract class ResourceRemoteDataSource {
  Future<Either<Failure, List<ResourceModel>>> getResourceList(int studentId);
}

class ResourceRemoteDataSourceImpl extends ResourceRemoteDataSource {
  final DioClient dioClient;

  ResourceRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<Either<Failure, List<ResourceModel>>> getResourceList(int studentId) async {
    try {
      // محاكاة بيانات JSON كما لو كانت قادمة من السيرفر
      final List<Map<String, dynamic>> mockJsonList = [
        {
          "id": "math_res_001",
          "title": "شرح نظرية فيثاغورس",
          "description": "فيديو تفاعلي يشرح تطبيقات نظرية فيثاغورس في الحياة العملية",
          "url": "https://example.com/videos/pythagoras",
          "teacherId": "teacher_math_202",
          "createdAt": "2023-10-15T14:30:00.000"
        },
        {
          "id": "phy_res_045",
          "title": "تجارب نيوتن في الجاذبية",
          "description": "مقال علمي يشرح تجارب نيوتن الأصلية مع تحليل رياضي",
          "url": "https://example.com/articles/newton-gravity",
          "teacherId": "teacher_phy_307",
          "createdAt": "2023-11-03T09:15:00.000"
        },
        {
          "id": "hist_res_102",
          "title": "وثائق الحرب العالمية الثانية",
          "description": "أرشيف كامل لوثائق وصور نادرة من الحرب العالمية الثانية",
          "url": "https://example.com/docs/ww2-archive",
          "teacherId": "teacher_hist_115",
          "createdAt": "2023-09-28T16:45:00.000"
        },
        {
          "id": "gen_res_201",
          "title": "دليل كتابة الأبحاث العلمية",
          "description": "دليل شامل لكتابة الأبحاث الأكاديمية باحترافية",
          "url": "https://example.com/guides/research-writing",
          "teacherId": "teacher_arabic_422",
          "createdAt": "2023-12-01T11:20:00.000"
        },
        {
          "id": "prog_res_033",
          "title": "تعلم Dart من الصفر",
          "description": "سلسلة فيديوهات لتعلم لغة دارت لطلاب علوم الحاسب",
          "url": "https://example.com/courses/dart-basics",
          "teacherId": "teacher_cs_501",
          "createdAt": "2023-10-22T10:00:00.000"
        },
      ];

      final resources = mockJsonList
          .map<ResourceModel>((json) => ResourceModel.fromJson(json))
          .toList();
      _logSuccess('[ResourceRemoteDataSourceImpl] Loaded resources: ${resources.length} items');
      return Right(resources);
    } catch (e, stackTrace) {
      _logError('[ResourceRemoteDataSourceImpl] Error loading resources: $e', stackTrace);
      return Left(ServerFailure(message: 'حدث خطأ أثناء تحميل الموارد. الرجاء المحاولة مرة أخرى.'));
    }
  }

  void _logSuccess(String message) {
    print('✅ $message');
  }

  void _logError(String message, StackTrace stackTrace) {
    print('❌ $message');
    print('StackTrace: $stackTrace');
  }
}