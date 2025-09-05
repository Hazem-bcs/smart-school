import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';
import '../models/zoom_meeting_model.dart';
import '../models/meeting_option_model.dart';

abstract class ZoomMeetingRemoteDataSource {
  Future<Either<Failure, ZoomMeetingModel>> scheduleMeeting(ZoomMeetingModel meeting);
  Future<Either<Failure, List<String>>> getAvailableClasses();
  Future<Either<Failure, List<MeetingOptionModel>>> getMeetingOptions();
  Future<Either<Failure, List<ZoomMeetingModel>>> getScheduledMeetings();
  Future<Either<Failure, String>> getJoinLink(String meetingId);
}

class ZoomMeetingRemoteDataSourceImpl implements ZoomMeetingRemoteDataSource {
  Either<Failure, T> _parseWrappedObject<T>(
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
      final Map<String, dynamic> data = Map<String, dynamic>.from(decoded['data'] as Map);
      return Right(fromJson(data));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  Either<Failure, List<T>> _parseWrappedList<T>(
    String jsonString,
    T Function(dynamic) mapItem,
  ) {
    try {
      final Map<String, dynamic> decoded = jsonDecode(jsonString) as Map<String, dynamic>;
      final int status = decoded['status'] is int ? decoded['status'] as int : 500;
      if (status != 200) {
        final String message = decoded['message']?.toString() ?? 'حدث خطأ في الخادم';
        return Left(ServerFailure(message: message, statusCode: status));
      }
      final List<dynamic> data = List<dynamic>.from(decoded['data'] as List);
      final List<T> items = data.map((e) => mapItem(e)).toList();
      return Right(items);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
  @override
  Future<Either<Failure, ZoomMeetingModel>> scheduleMeeting(ZoomMeetingModel meeting) async {
    // ********************************************************
    // مؤقتاً: JSON محلي إلى أن يجهز الـ back-end.
    // عند الجاهزية احذف ما بين سطري النجوم وفك التعليق عن الكتلة أدناه.
    // ********************************************************
    final String mockJson = '''
    {
      "data": {
        "id": "${DateTime.now().millisecondsSinceEpoch}",
        "topic": "${meeting.topic}",
        "invitedClasses": ${jsonEncode(meeting.invitedClasses)},
        "scheduledDate": "${meeting.scheduledDate.toIso8601String()}",
        "scheduledTime": "${meeting.scheduledTime.toIso8601String()}",
        "enableWaitingRoom": ${meeting.enableWaitingRoom},
        "recordAutomatically": ${meeting.recordAutomatically},
        "meetingUrl": "https://zoom.us/j/123456789",
        "meetingId": "123456789",
        "password": "123456"
      },
      "message": "تم جدولة الاجتماع بنجاح",
      "status": 200
    }
    ''';
    return _parseWrappedObject<ZoomMeetingModel>(mockJson, (m) => ZoomMeetingModel.fromJson(m));

    /*
    // الكتلة الحقيقية لاستدعاء الـ API (قم بإلغاء التعليق عند جاهزية الـ back-end)
    // import 'package:core/network/dio_client.dart';
    // final dio = DioClient(baseUrl: 'YOUR_BASE_URL', getToken: YOUR_GET_TOKEN);
    // final result = await dio.post('/zoom/schedule', data: meeting.toJson());
    // return result.fold(
    //   (failure) => Left(failure),
    //   (response) {
    //     final int status = response.data['status'] as int? ?? 500;
    //     if (status != 200) {
    //       final String message = response.data['message']?.toString() ?? 'خطأ غير متوقع';
    //       return Left(ServerFailure(message: message, statusCode: status));
    //     }
    //     final Map<String, dynamic> data = response.data['data'] as Map<String, dynamic>;
    //     return Right(ZoomMeetingModel.fromJson(data));
    //   },
    // );
    */
  }

  @override
  Future<Either<Failure, List<String>>> getAvailableClasses() async {
    // ********************************************************
    // مؤقتاً: JSON محلي إلى أن يجهز الـ back-end.
    // عند الجاهزية احذف ما بين سطري النجوم وفك التعليق عن الكتلة أدناه.
    // ********************************************************
    const String mockJson = '''
    {
      "data": ["Math 101", "History 202", "Science 303", "Art Elective", "English 404", "Physics 505"],
      "message": "تم جلب الفصول المتاحة بنجاح",
      "status": 200
    }
    ''';
    return _parseWrappedList<String>(mockJson, (e) => e.toString());

    /*
    // الكتلة الحقيقية لاستدعاء الـ API (قم بإلغاء التعليق عند جاهزية الـ back-end)
    // import 'package:core/network/dio_client.dart';
    // final dio = DioClient(baseUrl: 'YOUR_BASE_URL', getToken: YOUR_GET_TOKEN);
    // final result = await dio.get('/zoom/available-classes');
    // return result.fold(
    //   (failure) => Left(failure),
    //   (response) {
    //     final int status = response.data['status'] as int? ?? 500;
    //     if (status != 200) {
    //       final String message = response.data['message']?.toString() ?? 'خطأ غير متوقع';
    //       return Left(ServerFailure(message: message, statusCode: status));
    //     }
    //     final List<dynamic> data = response.data['data'] as List<dynamic>;
    //     return Right(data.map((e) => e.toString()).toList());
    //   },
    // );
    */
  }

  @override
  Future<Either<Failure, List<MeetingOptionModel>>> getMeetingOptions() async {
    // ********************************************************
    // مؤقتاً: JSON محلي إلى أن يجهز الـ back-end.
    // عند الجاهزية احذف ما بين سطري النجوم وفك التعليق عن الكتلة أدناه.
    // ********************************************************
    const String mockJson = '''
    {
      "data": [
        {
          "id": "waiting_room",
          "title": "تفعيل غرفة الانتظار",
          "isEnabled": true,
          "description": "ينتظر المشاركون في غرفة افتراضية حتى يتم قبولهم"
        },
        {
          "id": "record_meeting",
          "title": "تسجيل الاجتماع تلقائياً",
          "isEnabled": false,
          "description": "تسجيل الاجتماع تلقائياً عند البداية"
        }
      ],
      "message": "تم جلب خيارات الاجتماع بنجاح",
      "status": 200
    }
    ''';
    return _parseWrappedList<MeetingOptionModel>(mockJson, (e) => MeetingOptionModel.fromJson(Map<String, dynamic>.from(e as Map)));

    /*
    // الكتلة الحقيقية لاستدعاء الـ API (قم بإلغاء التعليق عند جاهزية الـ back-end)
    // import 'package:core/network/dio_client.dart';
    // final dio = DioClient(baseUrl: 'YOUR_BASE_URL', getToken: YOUR_GET_TOKEN);
    // final result = await dio.get('/zoom/options');
    // return result.fold(
    //   (failure) => Left(failure),
    //   (response) {
    //     final int status = response.data['status'] as int? ?? 500;
    //     if (status != 200) {
    //       final String message = response.data['message']?.toString() ?? 'خطأ غير متوقع';
    //       return Left(ServerFailure(message: message, statusCode: status));
    //     }
    //     final List<dynamic> data = response.data['data'] as List<dynamic>;
    //     return Right(data.map((e) => MeetingOptionModel.fromJson(Map<String, dynamic>.from(e as Map))).toList());
    //   },
    // );
    */
  }

  @override
  Future<Either<Failure, List<ZoomMeetingModel>>> getScheduledMeetings() async {
    // ********************************************************
    // مؤقتاً: JSON محلي إلى أن يجهز الـ back-end.
    // عند الجاهزية احذف ما بين سطري النجوم وفك التعليق عن الكتلة أدناه.
    // ********************************************************
    final String mockJson = '''
    {
      "data": [
        {
          "id": "1001",
          "topic": "مراجعة الوحدة الأولى",
          "invitedClasses": ["Math 101", "Science 303"],
          "scheduledDate": "${DateTime.now().add(const Duration(days: 1)).toIso8601String()}",
          "scheduledTime": "${DateTime.now().add(const Duration(days: 1, hours: 2)).toIso8601String()}",
          "enableWaitingRoom": true,
          "recordAutomatically": false,
          "meetingUrl": "https://zoom.us/j/1001",
          "meetingId": "1001",
          "password": "abc123"
        },
        {
          "id": "1002",
          "topic": "جلسة نقاش",
          "invitedClasses": ["History 202"],
          "scheduledDate": "${DateTime.now().add(const Duration(days: 2)).toIso8601String()}",
          "scheduledTime": "${DateTime.now().add(const Duration(days: 2, hours: 1)).toIso8601String()}",
          "enableWaitingRoom": true,
          "recordAutomatically": true,
          "meetingUrl": "https://zoom.us/j/1002",
          "meetingId": "1002",
          "password": "xyz789"
        }
      ],
      "message": "تم جلب الاجتماعات بنجاح",
      "status": 200
    }
    ''';
    return _parseWrappedList<ZoomMeetingModel>(
      mockJson,
      (e) => ZoomMeetingModel.fromJson(Map<String, dynamic>.from(e as Map)),
    );

    /*
    // الكتلة الحقيقية لاستدعاء الـ API (قم بإلغاء التعليق عند جاهزية الـ back-end)
    // import 'package:core/network/dio_client.dart';
    // final dio = DioClient(baseUrl: 'YOUR_BASE_URL', getToken: YOUR_GET_TOKEN);
    // final result = await dio.get('/zoom/scheduled');
    // return result.fold(
    //   (failure) => Left(failure),
    //   (response) {
    //     final int status = response.data['status'] as int? ?? 500;
    //     if (status != 200) {
    //       final String message = response.data['message']?.toString() ?? 'خطأ غير متوقع';
    //       return Left(ServerFailure(message: message, statusCode: status));
    //     }
    //     final List<dynamic> data = response.data['data'] as List<dynamic>;
    //     return Right(data.map((e) => ZoomMeetingModel.fromJson(Map<String, dynamic>.from(e as Map))).toList());
    //   },
    // );
    */
  }

  @override
  Future<Either<Failure, String>> getJoinLink(String meetingId) async {
    // ********************************************************
    // مؤقتاً: JSON محلي إلى أن يجهز الـ back-end.
    // عند الجاهزية احذف ما بين سطري النجوم وفك التعليق عن الكتلة أدناه.
    // ********************************************************
    const String mockJson = '''
    {
      "data": { "url": "https://zoom.us/j/123456789" },
      "message": "تم جلب رابط الانضمام",
      "status": 200
    }
    ''';
    try {
      final Map<String, dynamic> decoded = jsonDecode(mockJson) as Map<String, dynamic>;
      final int status = decoded['status'] as int? ?? 500;
      if (status != 200) {
        return Left(ServerFailure(message: decoded['message']?.toString() ?? 'خطأ غير متوقع', statusCode: status));
      }
      final String url = decoded['data']?['url']?.toString() ?? '';
      if (url.isEmpty) return const Left(ValidationFailure(message: 'رابط غير صالح'));
      return Right(url);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }

    /*
    // الكتلة الحقيقية لاستدعاء الـ API (قم بإلغاء التعليق عند جاهزية الـ back-end)
    // import 'package:core/network/dio_client.dart';
    // final dio = DioClient(baseUrl: 'YOUR_BASE_URL', getToken: YOUR_GET_TOKEN);
    // final result = await dio.get('/zoom/meetings/$meetingId/join-link');
    // return result.fold(
    //   (failure) => Left(failure),
    //   (response) {
    //     final int status = response.data['status'] as int? ?? 500;
    //     if (status != 200) {
    //       final String message = response.data['message']?.toString() ?? 'خطأ غير متوقع';
    //       return Left(ServerFailure(message: message, statusCode: status));
    //     }
    //     final String url = response.data['data']?['url']?.toString() ?? '';
    //     if (url.isEmpty) return const Left(ValidationFailure(message: 'رابط غير صالح'));
    //     return Right(url);
    //   },
    // );
    */
  }
} 