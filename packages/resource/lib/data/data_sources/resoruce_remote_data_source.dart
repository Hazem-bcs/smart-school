import 'package:core/network/dio_client.dart';
import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';

import '../models/resource_model.dart';

abstract class ResourceRemoteDataSource {
  Future<Either<Failure,List<ResourceModel>>> getResourceList(int studentId);
}

class ResourceRemoteDataSourceImpl extends ResourceRemoteDataSource {
  final DioClient dioClient;

  ResourceRemoteDataSourceImpl({required this.dioClient});
  @override
  Future<Either<Failure, List<ResourceModel>>> getResourceList(int studentId) async {
    return Right([
      ResourceModel(
        id: "math_res_001",
        title: "شرح نظرية فيثاغورس",
        description: "فيديو تفاعلي يشرح تطبيقات نظرية فيثاغورس في الحياة العملية",
        url: "https://example.com/videos/pythagoras",
        teacherId: "teacher_math_202",
        createdAt: DateTime(2023, 10, 15, 14, 30),
      ),

      ResourceModel(
        id: "phy_res_045",
        title: "تجارب نيوتن في الجاذبية",
        description: "مقال علمي يشرح تجارب نيوتن الأصلية مع تحليل رياضي",
        url: "https://example.com/articles/newton-gravity",
        teacherId: "teacher_phy_307",
        createdAt: DateTime(2023, 11, 3, 9, 15),
      ),

      ResourceModel(
        id: "hist_res_102",
        title: "وثائق الحرب العالمية الثانية",
        description: "أرشيف كامل لوثائق وصور نادرة من الحرب العالمية الثانية",
        url: "https://example.com/docs/ww2-archive",
        teacherId: "teacher_hist_115",
        createdAt: DateTime(2023, 9, 28, 16, 45),
      ),

      ResourceModel(
        id: "gen_res_201",
        title: "دليل كتابة الأبحاث العلمية",
        description: "دليل شامل لكتابة الأبحاث الأكاديمية باحترافية",
        url: "https://example.com/guides/research-writing",
        teacherId: "teacher_arabic_422",
        createdAt: DateTime(2023, 12, 1, 11, 20),
      ),

      ResourceModel(
        id: "prog_res_033",
        title: "تعلم Dart من الصفر",
        description: "سلسلة فيديوهات لتعلم لغة دارت لطلاب علوم الحاسب",
        url: "https://example.com/courses/dart-basics",
        teacherId: "teacher_cs_501",
        createdAt: DateTime(2023, 10, 22, 10, 0),
      ),
    ]);
  }


}