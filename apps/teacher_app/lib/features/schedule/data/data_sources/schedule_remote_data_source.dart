import 'dart:convert';
import 'dart:math' as math;
import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';
import 'package:core/network/dio_client.dart';
import '../models/schedule_model.dart';

abstract class ScheduleRemoteDataSource {
  Future<Either<Failure, List<ScheduleModel>>> getScheduleForDate(DateTime date);
}

class ScheduleRemoteDataSourceImpl implements ScheduleRemoteDataSource {
  final DioClient dioClient;

  ScheduleRemoteDataSourceImpl({required this.dioClient});

  Either<Failure, List<ScheduleModel>> _parseWrappedList(
    String jsonString,
  ) {
    try {
      final Map<String, dynamic> decoded = jsonDecode(jsonString) as Map<String, dynamic>;
      final int status = decoded['status'] is int ? decoded['status'] as int : 500;
      if (status != 200) {
        final String message = decoded['message']?.toString() ?? 'حدث خطأ في الخادم';
        return Left(ServerFailure(message: message, statusCode: status));
      }
      final dynamic rawData = decoded['data'];
      if (rawData is List) {
        final items = rawData
            .map((e) => ScheduleModel.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
        return Right(items);
      } else if (rawData is Map<String, dynamic>) {
        // دعم شكل: { data: { items: [...], isHoliday: true, holidayTitle: '...' } }
        final Map<String, dynamic> mapData = Map<String, dynamic>.from(rawData);
        final bool isHoliday = mapData['isHoliday'] == true;
        if (isHoliday) {
          final String title = (mapData['holidayTitle']?.toString() ?? 'عطلة رسمية');
          final ScheduleModel holiday = ScheduleModel.fromJson({
            'id': 'holiday_${DateTime.now().millisecondsSinceEpoch}',
            'title': title,
            'description': 'لا توجد حصص اليوم',
            'startTime': DateTime.now().toIso8601String(),
            'endTime': DateTime.now().toIso8601String(),
            'className': '',
            'subject': '',
            'teacherId': '',
            'location': '',
            'type': 'holiday',
            'status': 'upcoming',
          });
          return Right([holiday]);
        }
        final List<dynamic> itemsList = (mapData['items'] as List<dynamic>? ?? []);
        final items = itemsList
            .map((e) => ScheduleModel.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
        return Right(items);
      }
      return const Left(ValidationFailure(message: 'تنسيق البيانات غير صحيح'));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ScheduleModel>>> getScheduleForDate(DateTime date) async {
    // ********************************************************
    // API وهمي (JSON ثابت) وفق الاستجابة الموحدة { data, message, status }
    // مبدّل عشوائي بين يوم عطلة كامل وقائمة دوام عادية
    final bool isHolidayDay = math.Random().nextBool();
    final String mockJson = isHolidayDay
        ? '''
    {
      "data": {
        "isHoliday": true,
        "holidayTitle": "عطلة رسمية",
        "items": []
      },
      "message": "تم تحميل الجدول بنجاح",
      "status": 200
    }
    '''
        : '''
    {
      "data": [
        {
          "id": "math101",
          "title": "الرياضيات",
          "description": "درس الرياضيات الأساسي",
          "startTime": "2024-01-01T09:00:00.000Z",
          "endTime": "2024-01-01T10:00:00.000Z",
          "className": "الصف الأول",
          "subject": "الرياضيات",
          "teacherId": "teacher1",
          "location": "الفصل 101",
          "type": "class",
          "status": "upcoming"
        },
        {
          "id": "sci202",
          "title": "العلوم",
          "description": "درس العلوم التجريبي",
          "startTime": "2024-01-01T10:30:00.000Z",
          "endTime": "2024-01-01T11:30:00.000Z",
          "className": "الصف الأول",
          "subject": "العلوم",
          "teacherId": "teacher2",
          "location": "المختبر 201",
          "type": "class",
          "status": "upcoming"
        }
      ],
      "message": "تم تحميل الجدول بنجاح",
      "status": 200
    }
    ''';
    await Future.delayed(const Duration(milliseconds: 500));
    final fake = _parseWrappedList(mockJson);
    if (fake.isRight()) return fake;
    // ********************************************************

    /*
    // الكتلة الحقيقية لاستدعاء الـ API (قم بإلغاء التعليق عند جاهزية الـ back-end)
    // final result = await dioClient.get('/schedule', options: Options(queryParameters: {
    //   'date': date.toIso8601String(),
    // }));
    // return result.fold(
    //   (failure) => Left(failure),
    //   (response) {
    //     final data = response.data as Map<String, dynamic>?;
    //     final int status = data?['status'] is int ? data!['status'] as int : 500;
    //     if (status != 200) {
    //       final String message = data?['message']?.toString() ?? 'حدث خطأ غير متوقع';
    //       return Left(ServerFailure(message: message, statusCode: status));
    //     }
    //     final List<dynamic> list = data?['data'] as List<dynamic>? ?? [];
    //     final items = list
    //         .map((e) => ScheduleModel.fromJson(Map<String, dynamic>.from(e as Map)))
    //         .toList();
    //     return Right(items);
    //   },
    // );
    */

    return fake; // fallback على الوهمي لحين الجاهزية
  }
} 