import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';
import 'package:core/network/dio_client.dart';
import '../../models/assignment_model.dart';
import '../../../domain/entities/assignment.dart';

abstract class AssignmentRemoteDataSource {
  Future<Either<Failure, List<AssignmentModel>>> getAssignments({String? searchQuery, AssignmentStatus? filter});
}

class AssignmentRemoteDataSourceImpl implements AssignmentRemoteDataSource {
  final DioClient dioClient;

  AssignmentRemoteDataSourceImpl({required this.dioClient});

  Either<Failure, List<AssignmentModel>> _parseWrappedList(String jsonString) {
    try {
      final Map<String, dynamic> decoded = jsonDecode(jsonString) as Map<String, dynamic>;
      final int status = decoded['status'] is int ? decoded['status'] as int : 500;
      if (status != 200) {
        final String message = decoded['message']?.toString() ?? 'حدث خطأ في الخادم';
        return Left(ServerFailure(message: message, statusCode: status));
      }
      final List<dynamic> data = List<dynamic>.from(decoded['data'] as List);
      final list = data
          .map((e) => AssignmentModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
      return Right(list);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AssignmentModel>>> getAssignments({String? searchQuery, AssignmentStatus? filter}) async {
    // ********************************************************
    // API وهمي (JSON ثابت) وفق الاستجابة الموحدة { data, message, status }
    const String mockJson = '''
    {
      "data": [
        {
          "id": "1",
          "title": "واجب الرياضيات - اختبار قصير",
          "subtitle": "تسليم: 26 أكتوبر · 25/25 تم التسليم",
          "isCompleted": true,
          "dueDate": "2024-10-26T00:00:00.000",
          "submittedCount": 25,
          "totalCount": 25,
          "status": "graded"
        },
        {
          "id": "2",
          "title": "مشروع العلوم - التجربة الحرارية",
          "subtitle": "تسليم: 27 أكتوبر · 20/25 تم التسليم",
          "isCompleted": false,
          "dueDate": "2024-10-27T00:00:00.000",
          "submittedCount": 20,
          "totalCount": 25,
          "status": "ungraded"
        },
        {
          "id": "3",
          "title": "مقال اللغة الإنجليزية",
          "subtitle": "تسليم: 28 أكتوبر · 25/25 تم التسليم",
          "isCompleted": true,
          "dueDate": "2024-10-28T00:00:00.000",
          "submittedCount": 25,
          "totalCount": 25,
          "status": "graded"
        },
        {
          "id": "4",
          "title": "تقرير التاريخ - الحضارة الإسلامية",
          "subtitle": "تسليم: 29 أكتوبر · 22/25 تم التسليم",
          "isCompleted": false,
          "dueDate": "2024-10-29T00:00:00.000",
          "submittedCount": 22,
          "totalCount": 25,
          "status": "ungraded"
        },
        {
          "id": "5",
          "title": "محفظة الفنون - أعمال إبداعية",
          "subtitle": "تسليم: 30 أكتوبر · 25/25 تم التسليم",
          "isCompleted": true,
          "dueDate": "2024-10-30T00:00:00.000",
          "submittedCount": 25,
          "totalCount": 25,
          "status": "graded"
        }
      ],
      "message": "تم جلب الواجبات بنجاح",
      "status": 200
    }
    ''';
    await Future.delayed(const Duration(milliseconds: 600));
    final mockResult = _parseWrappedList(mockJson);
    if (mockResult.isLeft()) return mockResult; // في حال فشل غير متوقع في التفكيك
    // تطبيق البحث والفلترة محلياً على النتائج الوهمية
    return mockResult.fold(
      (failure) => Left(failure),
      (list) {
        List<AssignmentModel> filtered = List<AssignmentModel>.from(list);
        if (searchQuery != null && searchQuery.trim().isNotEmpty) {
          final q = searchQuery.toLowerCase();
          filtered = filtered.where((a) =>
            a.title.toLowerCase().contains(q) || a.subtitle.toLowerCase().contains(q)
          ).toList();
        }
        if (filter != null && filter != AssignmentStatus.all) {
          filtered = filtered.where((a) => a.status == filter).toList();
        }
        return Right(filtered);
      },
    );
    // ********************************************************

    /*
    // الكتلة الحقيقية لاستدعاء الـ API (قم بإلغاء التعليق عند جاهزية الـ back-end)
    // final result = await dioClient.get('/assignments', queryParameters: {
    //   if (searchQuery != null && searchQuery.isNotEmpty) 'q': searchQuery,
    //   if (filter != null && filter != AssignmentStatus.all) 'status': filter.toString().split('.').last,
    // });
    // return result.fold(
    //   (failure) => Left(failure),
    //   (response) {
    //     final data = response.data as Map<String, dynamic>?;
    //     final int status = data?['status'] is int ? data!['status'] as int : 500;
    //     if (status != 200) {
    //       final String message = data?['message']?.toString() ?? 'حدث خطأ غير متوقع';
    //       return Left(ServerFailure(message: message, statusCode: status));
    //     }
    //     final List<dynamic> items = List<dynamic>.from(data?['data'] as List);
    //     final list = items
    //         .map((e) => AssignmentModel.fromJson(Map<String, dynamic>.from(e as Map)))
    //         .toList();
    //     return Right(list);
    //   },
    // );
    */
  }
}

// Assignment Remote Data Source Implementation:
// - Mock Data: داخل أسطر النجوم أعلاه وفق { data, message, status }
// - Real Call: كتلة DioClient معلّقة بنفس الشكل دائماً
// - Error Handling: إعادة Either<Failure, T> برسائل عربية واضحة
// - No exceptions thrown upward
// - Search & Filter: محلية على البيانات الوهمية فقط