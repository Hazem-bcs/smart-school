import 'dart:convert';
import 'package:core/constant.dart';
import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';
import 'package:core/network/dio_client.dart';
import '../models/class_model.dart';
import '../models/assignment_model.dart';
import '../models/notification_model.dart';

abstract class HomeRemoteDataSource {
  Future<Either<Failure, List<ClassModel>>> getClasses(int teacherId);
  Future<Either<Failure, List<AssignmentModel>>> getAssignments();
  Future<Either<Failure, List<NotificationModel>>> getNotifications();
  Future<Either<Failure, Unit>> markNotificationAsRead(String notificationId);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final DioClient dioClient;

  HomeRemoteDataSourceImpl({required this.dioClient});

  static const List<String> _defaultClassImages = [
    'https://lh3.googleusercontent.com/aida-public/AB6AXuD9w7tCpSPAzZbbubs-iE5xRO73QdEsyxz7VIrvaDOC2W-5S_ZX_Fang8iFy1YMxgEQYmT9omrIo0qTpXy371S4uAPK8KGB4-8N1TeKR-4AEJdjQQASd9ry1G_I_xy9wV5klMCitHQPmHnglClnCK5RJ4BsNh_fjI7L3lTJSxNk31hD3hCpHT6DfA8vitj9o3wtzF2kEba-_DNsuup5vVxwtOIXUoxtWtdhu4mNST8xLYEhjHevxpBx5tnCVzVtvofVbqEIHBd0Qs-R',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuBGTNtMBdZd29vc_g_lJKl6sErAKhO3PZ_Z7vYrNQnFstP1RHfWS_D2PIXM2vv-cr_hkFX70XwwzPmpkXrvgDb-XO56z9R2C7dw4wfoz5mNynCbdgZE7DbVEeZPpiZckbfDiKnGU4wBblxNLiYe6loCUzk6bGjlxkTFRhAZSgQJVLEh3nxUSJPxXxPg98krRv9z7GULa3DbDLXi-qJ3aDbSmcCSaI5pGxTrKRKzg5BZwqIVZQW8kLSCE_YBiBVMHGSrb1A7SNjufKhB',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuBhhBn8oRkJqk7jGmNa5C2D1sMLpKgtUvUjl6Ydoh9Om0F7cv_EtphZw85Qo-Fcvs-NhDKRAyNiOrjMCVVHNt18SuTEJc-v99b3jSPa32bdX_V63LGcdoF-EttOmh2ty3eZOc0u29OKmRQYSDkRO2cAYrb3iqbP2vbBIsYtTzL3y0sV_C5E9yBk6I3JGStxCTfqQ_mn-wyi9zH7_juJ5EqJdY4V4qC9vMZdu3hG9k2y8xMF5z00HLRfHhTa1LUnPKMcfMGJQnF6WyUM',
  ];

  Either<Failure, List<T>> _parseWrappedList<T>(
    String jsonString,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    try {
      final Map<String, dynamic> decoded = jsonDecode(jsonString) as Map<String, dynamic>;
      final int status = decoded['status'] is int ? decoded['status'] as int : 500;
      if (status != 200) {
        final String message = decoded['message']?.toString() ?? 'حدث خطأ في الخادم';
        return Left(ServerFailure(message: message, statusCode: status));
      }

      final dynamic rawData = decoded['data'];
      List<dynamic> listData;
      if (rawData is List) {
        listData = rawData;
      } else if (rawData is Map<String, dynamic> && rawData['items'] is List) {
        listData = rawData['items'] as List<dynamic>;
      } else {
        return const Left(ValidationFailure(message: 'تنسيق البيانات غير صحيح'));
      }

      final List<T> items = listData
          .map((e) => fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
      return Right(items);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ClassModel>>> getClasses(int teacherId) async {
    try {
      final result = await dioClient.post(
        Constants.getAllClasses,
        data: {
          'teacher_id': teacherId,
        },
      );

      return result.fold(
        (failure) => Left(failure),
        (response) {
          final dynamic body = response.data;
          if (body is! Map<String, dynamic>) {
            return const Left(ValidationFailure(message: 'تنسيق الاستجابة غير صحيح'));
          }

          final int status = body['status'] is int ? body['status'] as int : 500;
          if (status != 200) {
            final String message = body['message']?.toString() ?? 'حدث خطأ في الخادم';
            return Left(ServerFailure(message: message, statusCode: status));
          }

          final dynamic data = body['data'];
          if (data is! List) {
            return const Left(ValidationFailure(message: 'تنسيق البيانات غير صحيح'));
          }

          final List<ClassModel> classes = data.asMap().entries.map((entry) {
            final int index = entry.key;
            final Map<String, dynamic> m = Map<String, dynamic>.from(entry.value as Map);
            final String section = (m['section'] ?? '').toString();
            final String classroom = (m['classroom'] ?? '').toString();
            final List<dynamic> subjectsRaw = (m['subjects'] is List) ? m['subjects'] as List : const [];
            final String subject = subjectsRaw.isNotEmpty ? subjectsRaw.first.toString() : '';

            return ClassModel(
              id: '${classroom}_$section',
              title: classroom.isNotEmpty && section.isNotEmpty ? '$classroom - شعبة $section' : classroom,
              imageUrl: _defaultClassImages[index % _defaultClassImages.length],
              studentCount: 0,
              subject: subject,
            );
          }).toList().cast<ClassModel>();

          return Right(classes);
        },
      );
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AssignmentModel>>> getAssignments() async {
    // ********************************************************
    // مؤقتاً: JSON محلي إلى أن يجهز الـ back-end.
    // عند الجاهزية احذف ما بين سطري النجوم وفك التعليق عن الكتلة أدناه.
    // ********************************************************
    final String mockJson = '''
    {
      "data": [
        {
          "id": "1",
          "title": "Essay on World War II",
          "subtitle": "Due in 2 days",
          "dueDate": "${DateTime.now().add(const Duration(days: 2)).toIso8601String()}",
          "status": "pending"
        },
        {
          "id": "2",
          "title": "Math Quiz",
          "subtitle": "Due in 5 days",
          "dueDate": "${DateTime.now().add(const Duration(days: 5)).toIso8601String()}",
          "status": "pending"
        }
      ],
      "message": "تم الجلب بنجاح",
      "status": 200
    }
    ''';
    return _parseWrappedList<AssignmentModel>(mockJson, (m) => AssignmentModel.fromJson(m));

    /*
    // الكتلة الحقيقية لاستدعاء الـ API (قم بإلغاء التعليق عند جاهزية الـ back-end)
    // import 'package:core/network/dio_client.dart';
    // final dio = DioClient(baseUrl: 'YOUR_BASE_URL', getToken: YOUR_GET_TOKEN);
    // final result = await dio.get('/assignments');
    // return result.fold(
    //   (failure) => throw Exception(failure.message),
    //   (response) {
    //     final int status = response.data['status'] as int? ?? 500;
    //     if (status != 200) {
    //       final String message = response.data['message']?.toString() ?? 'خطأ غير متوقع';
    //       throw Exception(message);
    //     }
    //     final List<dynamic> data = response.data['data'] as List<dynamic>;
    //     return data
    //         .map((e) => AssignmentModel.fromJson(e as Map<String, dynamic>))
    //         .toList();
    //   },
    // );
    */
  }

  @override
  Future<Either<Failure, List<NotificationModel>>> getNotifications() async {
    // ********************************************************
    // مؤقتاً: JSON محلي إلى أن يجهز الـ back-end.
    // عند الجاهزية احذف ما بين سطري النجوم وفك التعليق عن الكتلة أدناه.
    // ********************************************************
    final String mockJson = '''
    {
      "data": [
        {
          "id": "1",
          "title": "New student joined Math 101",
          "subtitle": "10:00 AM",
          "timestamp": "${DateTime.now().subtract(const Duration(hours: 2)).toIso8601String()}",
          "isRead": false
        },
        {
          "id": "2",
          "title": "Assignment submitted for Math 101",
          "subtitle": "Yesterday",
          "timestamp": "${DateTime.now().subtract(const Duration(days: 1)).toIso8601String()}",
          "isRead": true
        }
      ],
      "message": "تم الجلب بنجاح",
      "status": 200
    }
    ''';
    return _parseWrappedList<NotificationModel>(mockJson, (m) => NotificationModel.fromJson(m));

    /*
    // الكتلة الحقيقية لاستدعاء الـ API (قم بإلغاء التعليق عند جاهزية الـ back-end)
    // import 'package:core/network/dio_client.dart';
    // final dio = DioClient(baseUrl: 'YOUR_BASE_URL', getToken: YOUR_GET_TOKEN);
    // final result = await dio.get('/notifications');
    // return result.fold(
    //   (failure) => throw Exception(failure.message),
    //   (response) {
    //     final int status = response.data['status'] as int? ?? 500;
    //     if (status != 200) {
    //       final String message = response.data['message']?.toString() ?? 'خطأ غير متوقع';
    //       throw Exception(message);
    //     }
    //     final List<dynamic> data = response.data['data'] as List<dynamic>;
    //     return data
    //         .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
    //         .toList();
    //   },
    // );
    */
  }

  @override
  Future<Either<Failure, Unit>> markNotificationAsRead(String notificationId) async {
    // ********************************************************
    // مؤقتاً: تنفيذ محلي إلى أن يجهز الـ back-end.
    // عند الجاهزية احذف ما بين سطري النجوم وفك التعليق عن الكتلة أدناه.
    // ********************************************************
    return const Right(unit);

    /*
    // الكتلة الحقيقية لاستدعاء الـ API (قم بإلغاء التعليق عند جاهزية الـ back-end)
    // import 'package:core/network/dio_client.dart';
    // final dio = DioClient(baseUrl: 'YOUR_BASE_URL', getToken: YOUR_GET_TOKEN);
    // final result = await dio.post('/notifications/$notificationId/read');
    // return result.fold(
    //   (failure) => Left(failure),
    //   (response) {
    //     final int status = response.data['status'] as int? ?? 500;
    //     if (status != 200) {
    //       final String message = response.data['message']?.toString() ?? 'خطأ غير متوقع';
    //       return Left(ServerFailure(message: message, statusCode: status));
    //     }
    //     return const Right(unit);
    //   },
    // );
    */
  }
} 