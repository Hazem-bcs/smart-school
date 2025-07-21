import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';
import '../models/schedule_model.dart';

abstract class ScheduleRemoteDataSource {
  Future<Either<Failure, List<ScheduleModel>>> getScheduleForDate(DateTime date);
}

class ScheduleRemoteDataSourceImpl implements ScheduleRemoteDataSource {
  
  // دالة مساعدة لطباعة معلومات الطلب
  void _printRequestInfo(String methodName, dynamic data) {
    print('🔵 [SCHEDULE] REQUEST: $methodName');
    print('📤 Data sent: $data');
    print('⏰ Timestamp: ${DateTime.now().toIso8601String()}');
    print('---');
  }

  // دالة مساعدة لطباعة معلومات الاستجابة
  void _printResponseInfo(String methodName, dynamic data, bool isSuccess) {
    print('🟢 [SCHEDULE] RESPONSE: $methodName');
    print('📥 Data received: $data');
    print('✅ Success: $isSuccess');
    print('⏰ Timestamp: ${DateTime.now().toIso8601String()}');
    print('---');
  }

  // دالة مساعدة لطباعة معلومات الخطأ
  void _printErrorInfo(String methodName, String errorMessage) {
    print('🔴 [SCHEDULE] ERROR: $methodName');
    print('❌ Error message: $errorMessage');
    print('⏰ Timestamp: ${DateTime.now().toIso8601String()}');
    print('---');
  }

  @override
  Future<Either<Failure, List<ScheduleModel>>> getScheduleForDate(DateTime date) async {
    // طباعة معلومات الطلب
    _printRequestInfo('getScheduleForDate', {
      'date': date.toIso8601String(),
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    // Simulate random error (10% chance)
    if (DateTime.now().millisecondsSinceEpoch % 10 == 0) {
      final errorMessage = 'خطأ في الاتصال بالخادم';
      _printErrorInfo('getScheduleForDate', errorMessage);
      return Left(ServerFailure(message: errorMessage));
    }

    try {
      // Mock response - in real app, this would be an API call
      final Map<String, dynamic> response = {
        'success': true,
        'statuscode': 200,
        'data': _generateMockScheduleData(date),
        'message': 'تم تحميل الجدول بنجاح',
      };

      if (response['success'] == true && response['statuscode'] == 200) {
        final List<dynamic> schedulesData = response['data'] as List<dynamic>;
        final schedules = schedulesData
            .map((data) => ScheduleModel.fromJson(data as Map<String, dynamic>))
            .toList();
        
        // طباعة معلومات الاستجابة الناجحة
        _printResponseInfo('getScheduleForDate', {
          'count': schedules.length,
          'date': date.toIso8601String(),
        }, true);
        
        return Right(schedules);
      } else {
        final errorMessage = response['message'] ?? 'خطأ غير معروف';
        _printErrorInfo('getScheduleForDate', errorMessage);
        return Left(ServerFailure(message: errorMessage));
      }
    } catch (e) {
      final errorMessage = 'خطأ في تحليل البيانات: $e';
      _printErrorInfo('getScheduleForDate', errorMessage);
      return Left(ServerFailure(message: 'خطأ في تحليل البيانات'));
    }
  }

  List<Map<String, dynamic>> _generateMockScheduleData(DateTime date) {
    final dayOfWeek = date.weekday;
    
    // Different schedules for different days
    switch (dayOfWeek) {
      case 1: // Monday
        return [
          {
            'id': 'math101_${date.millisecondsSinceEpoch}',
            'title': 'الرياضيات',
            'description': 'درس الرياضيات الأساسي',
            'startTime': '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}T09:00:00.000Z',
            'endTime': '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}T10:00:00.000Z',
            'className': 'الصف الأول',
            'subject': 'الرياضيات',
            'teacherId': 'teacher1',
            'location': 'الفصل 101',
            'type': 'lecture',
            'status': 'upcoming',
          },
          {
            'id': 'sci202_${date.millisecondsSinceEpoch}',
            'title': 'العلوم',
            'description': 'درس العلوم التجريبي',
            'startTime': '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}T10:30:00.000Z',
            'endTime': '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}T11:30:00.000Z',
            'className': 'الصف الأول',
            'subject': 'العلوم',
            'teacherId': 'teacher2',
            'location': 'المختبر 201',
            'type': 'lab',
            'status': 'upcoming',
          },
        ];
      case 2: // Tuesday
        return [
          {
            'id': 'his303_${date.millisecondsSinceEpoch}',
            'title': 'التاريخ',
            'description': 'درس التاريخ الإسلامي',
            'startTime': '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}T09:00:00.000Z',
            'endTime': '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}T10:00:00.000Z',
            'className': 'الصف الأول',
            'subject': 'التاريخ',
            'teacherId': 'teacher3',
            'location': 'الفصل 301',
            'type': 'lecture',
            'status': 'upcoming',
          },
        ];
      case 3: // Wednesday
        return [
          {
            'id': 'math101_${date.millisecondsSinceEpoch}',
            'title': 'الرياضيات',
            'description': 'درس الرياضيات المتقدم',
            'startTime': '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}T08:30:00.000Z',
            'endTime': '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}T09:30:00.000Z',
            'className': 'الصف الأول',
            'subject': 'الرياضيات',
            'teacherId': 'teacher1',
            'location': 'الفصل 101',
            'type': 'lecture',
            'status': 'completed',
          },
        ];
      case 4: // Thursday
        return [
          {
            'id': 'bio909_${date.millisecondsSinceEpoch}',
            'title': 'الأحياء',
            'description': 'درس الأحياء التجريبي',
            'startTime': '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}T09:00:00.000Z',
            'endTime': '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}T10:00:00.000Z',
            'className': 'الصف الأول',
            'subject': 'الأحياء',
            'teacherId': 'teacher4',
            'location': 'المختبر 401',
            'type': 'lab',
            'status': 'upcoming',
          },
        ];
      case 5: // Friday
        return [
          {
            'id': 'rel1111_${date.millisecondsSinceEpoch}',
            'title': 'التربية الإسلامية',
            'description': 'درس التربية الإسلامية',
            'startTime': '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}T09:00:00.000Z',
            'endTime': '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}T10:00:00.000Z',
            'className': 'الصف الأول',
            'subject': 'التربية الإسلامية',
            'teacherId': 'teacher5',
            'location': 'الفصل 501',
            'type': 'lecture',
            'status': 'upcoming',
          },
        ];
      default: // Weekend
        return [];
    }
  }
} 