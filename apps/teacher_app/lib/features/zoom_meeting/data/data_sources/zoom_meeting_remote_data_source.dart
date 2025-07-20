import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';
import '../models/zoom_meeting_model.dart';
import '../models/meeting_option_model.dart';

abstract class ZoomMeetingRemoteDataSource {
  Future<Either<Failure, ZoomMeetingModel>> scheduleMeeting(ZoomMeetingModel meeting);
  Future<Either<Failure, List<String>>> getAvailableClasses();
  Future<Either<Failure, List<MeetingOptionModel>>> getMeetingOptions();
}

class ZoomMeetingRemoteDataSourceImpl implements ZoomMeetingRemoteDataSource {
  @override
  Future<Either<Failure, ZoomMeetingModel>> scheduleMeeting(ZoomMeetingModel meeting) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));
    // Simulate random error (10% chance)
    if (DateTime.now().millisecondsSinceEpoch % 10 == 0) {
      return Left(ServerFailure(message: 'خطأ في الاتصال بالخادم'));
    }

    try {
      // Mock response - in real app, this would be an API call
      final Map<String, dynamic> response = {
        'success': true,
        'statuscode': 200,
        'data': {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'topic': meeting.topic,
          'invitedClasses': meeting.invitedClasses,
          'scheduledDate': meeting.scheduledDate.toIso8601String(),
          'scheduledTime': meeting.scheduledTime.toIso8601String(),
          'enableWaitingRoom': meeting.enableWaitingRoom,
          'recordAutomatically': meeting.recordAutomatically,
          'meetingUrl': 'https://zoom.us/j/123456789',
          'meetingId': '123456789',
          'password': '123456',
        },
        'message': 'تم جدولة الاجتماع بنجاح',
      };

      if (response['success'] == true && response['statuscode'] == 200) {
        final scheduledMeeting = ZoomMeetingModel.fromJson(response['data']);
        return Right(scheduledMeeting);
      } else {
        return Left(ServerFailure(message: response['message'] ?? 'خطأ غير معروف'));
      }
    } catch (e) {
      return Left(ServerFailure(message: 'خطأ في تحليل البيانات'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getAvailableClasses() async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Simulate random error (10% chance)
    if (DateTime.now().millisecondsSinceEpoch % 10 == 0) {
      return Left(ServerFailure(message: 'خطأ في الاتصال بالخادم'));
    }

    try {
      // Mock response - in real app, this would be an API call
      final Map<String, dynamic> response = {
        'success': true,
        'statuscode': 200,
        'data': [
          'Math 101',
          'History 202', 
          'Science 303',
          'Art Elective',
          'English 404',
          'Physics 505'
        ],
        'message': 'تم جلب الفصول المتاحة بنجاح',
      };

      if (response['success'] == true && response['statuscode'] == 200) {
        final classes = List<String>.from(response['data']);
        return Right(classes);
      } else {
        return Left(ServerFailure(message: response['message'] ?? 'خطأ غير معروف'));
      }
    } catch (e) {
      return Left(ServerFailure(message: 'خطأ في تحليل البيانات'));
    }
  }

  @override
  Future<Either<Failure, List<MeetingOptionModel>>> getMeetingOptions() async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Simulate random error (10% chance)
    if (DateTime.now().millisecondsSinceEpoch % 10 == 0) {
      return Left(ServerFailure(message: 'خطأ في الاتصال بالخادم'));
    }

    try {
      // Mock response - in real app, this would be an API call
      final Map<String, dynamic> response = {
        'success': true,
        'statuscode': 200,
        'data': [
          {
            'id': 'waiting_room',
            'title': 'Enable Waiting Room',
            'isEnabled': true,
            'description': 'Participants will wait in a virtual waiting room until you admit them',
          },
          {
            'id': 'record_meeting',
            'title': 'Record meeting automatically',
            'isEnabled': false,
            'description': 'Automatically record the meeting when it starts',
          },
        ],
        'message': 'تم جلب خيارات الاجتماع بنجاح',
      };

      if (response['success'] == true && response['statuscode'] == 200) {
        final options = (response['data'] as List)
            .map((json) => MeetingOptionModel.fromJson(json))
            .toList();
        return Right(options);
      } else {
        return Left(ServerFailure(message: response['message'] ?? 'خطأ غير معروف'));
      }
    } catch (e) {
      return Left(ServerFailure(message: 'خطأ في تحليل البيانات'));
    }
  }
} 