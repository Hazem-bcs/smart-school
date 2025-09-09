import 'dart:convert';
import 'package:core/constant.dart';
import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';
import 'package:core/network/dio_client.dart';
import '../models/schedule_model.dart';

abstract class ScheduleRemoteDataSource {
  Future<Either<Failure, List<ScheduleModel>>> getScheduleForDate(DateTime date, int teacherId);
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

  Either<Failure, List<ScheduleModel>> _parseWrappedMap(
    Map<String, dynamic> decoded,
  ) {
    try {
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
  Future<Either<Failure, List<ScheduleModel>>> getScheduleForDate(DateTime date, int teacherId) async {
    final String formattedDate = date.toIso8601String().split('T').first;
    final result = await dioClient.post(
      Constants.getScheduleForDateEndpoint,
      data: {
        'teacher_id': teacherId,
        'date': formattedDate,
      },
    );
    return result.fold(
      (failure) => Left(failure),
      (response) {
        final dynamic data = response.data;
        if (data is String) {
          return _parseWrappedList(data);
        } else if (data is Map<String, dynamic>) {
          return _parseWrappedMap(data);
        } else {
          return const Left(ValidationFailure(message: 'تنسيق الاستجابة غير متوقع'));
        }
      },
    );
  }
} 