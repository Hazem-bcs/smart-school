import 'package:core/network/dio_client.dart';
import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';

import '../models/resource_model.dart';

abstract class ResourceRemoteDataSource {
  Future<Either<Failure, List<ResourceModel>>> getResourceList(int studentId);
}

class ResourceRemoteDataSourceImpl implements ResourceRemoteDataSource {
  final DioClient dioClient;

  ResourceRemoteDataSourceImpl({required this.dioClient});

  // قائمة وهمية مؤقتة لحين جاهزية الـ back-end
  static final List<ResourceModel> _dummyList = [
    ResourceModel(
      id: '1',
      title: 'دليل الرياضيات للصف السادس',
      description: 'ملف PDF يحتوي على شرح مفصل لدروس الرياضيات.',
      url: 'https://example.com/resources/math6.pdf',
      teacherId: '101',
      targetClasses: ['6A', '6B'],
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    ResourceModel(
      id: '2',
      title: 'عرض بوربوينت: الطاقة المتجددة',
      description: 'عرض تقديمي حول مصادر الطاقة المتجددة.',
      url: 'https://example.com/resources/renewable-energy.pptx',
      teacherId: '102',
      targetClasses: ['7A'],
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    ResourceModel(
      id: '3',
      title: 'ورقة عمل علوم',
      description: 'ورقة عمل تفاعلية لمادة العلوم.',
      url: 'https://example.com/resources/science-worksheet.docx',
      teacherId: '103',
      targetClasses: ['8A', '8B'],
      createdAt: DateTime.now(),
    ),
  ];

  @override
  Future<Either<Failure, List<ResourceModel>>> getResourceList(int studentId) async {
    // عند عدم توفر الـ back-end، نعيد القائمة الوهمية مباشرة
    // يمكن لاحقاً تفعيل الكود الأصلي عند جاهزية الـ API
    await Future.delayed(const Duration(milliseconds: 500)); // محاكاة التأخير الشبكي
    return Right(_dummyList);

    // الكود الأصلي (يُستخدم عند جاهزية الـ back-end)
    /*
    try {
      final response = await dioClient.post(
        '/api/resources/list',
        data: {
          'student_id': studentId,
        },
      );

      return response.fold(
        (failure) => Left(failure),
        (response) {
          try {
            final data = response.data;
            if (data is List) {
              final resources = data
                  .map<ResourceModel>((json) => ResourceModel.fromJson(json as Map<String, dynamic>))
                  .toList();
              return Right(resources);
            } else if (data is Map && data['resources'] is List) {
              final resources = (data['resources'] as List)
                  .map<ResourceModel>((json) => ResourceModel.fromJson(json as Map<String, dynamic>))
                  .toList();
              return Right(resources);
            } else {
              return Left(ServerFailure(message: 'تنسيق البيانات غير صحيح من الخادم.'));
            }
          } catch (e) {
            return Left(ServerFailure(message: 'حدث خطأ أثناء معالجة البيانات: ${e.toString()}'));
          }
        },
      );
    } catch (e) {
      return Left(ServerFailure(message: 'حدث خطأ أثناء تحميل الموارد. الرجاء المحاولة مرة أخرى.'));
    }
    */
  }
}