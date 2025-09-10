import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';
import 'package:core/constant.dart';
import 'package:core/network/dio_client.dart';
import 'package:dio/dio.dart' show Options, Headers;
import 'package:teacher_app/core/local_data_source.dart';
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
  final DioClient dioClient;
  final LocalDataSource localDataSource;
  // يحتفظ بخريطة من نص العرض إلى معرّف القسم لإرساله إلى الباك-إند
  final Map<String, int> _sectionLabelToId = <String, int>{};

  ZoomMeetingRemoteDataSourceImpl({required this.dioClient, required this.localDataSource});

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
    try {
      final int? teacherId = await localDataSource.getUserId();
      if (teacherId == null) {
        return const Left(UnAuthenticated(message: 'الرجاء تسجيل الدخول مجدداً'));
      }
      // صياغة حقل start_at بالشكل "YYYY-MM-DD HH:MM:SS"
      final String datePart = '${meeting.scheduledDate.year.toString().padLeft(4, '0')}-${meeting.scheduledDate.month.toString().padLeft(2, '0')}-${meeting.scheduledDate.day.toString().padLeft(2, '0')}';
      final String timePart = '${meeting.scheduledTime.hour.toString().padLeft(2, '0')}:${meeting.scheduledTime.minute.toString().padLeft(2, '0')}:${meeting.scheduledTime.second.toString().padLeft(2, '0')}';
      final String startAt = '$datePart $timePart';

      // قيمة تجريبية افتراضية كما في Postman
      const int defaultDurationMinutes = 20;

      // تحويل الخيارات المحددة (أسماء العرض) إلى IDs حقيقية للأقسام
      final List<int> sectionIds = <int>[];
      for (final String label in meeting.invitedClasses) {
        final int? id = _sectionLabelToId[label];
        if (id != null) {
          sectionIds.add(id);
        }
      }
      // إذا اختير قسم واحد فقط، أرسل section_id كرقم مفرد
      Object sectionPayload;
      if (meeting.invitedClasses.length == 1) {
        final String label = meeting.invitedClasses.first;
        final int? singleId = _sectionLabelToId[label];
        if (singleId == null) {
          // مؤقتاً: قيمة تجريبية لتوافق نموذج Postman إذا لم يتوفر المعرّف من الـ API
          sectionPayload = 1;
        } else {
          sectionPayload = singleId;
        }
      } else {
        // في حال وجود أكثر من قسم، نُبقي على إرسال مصفوفة IDs إن وُجدت، وإلا أسماء العرض
        sectionPayload = sectionIds.isNotEmpty ? sectionIds : meeting.invitedClasses;
      }

      // تجهيز الباراميترات وفق ما نجح في Postman: section_id[]
      print('ZoomMeetingRemoteDataSource.scheduleMeeting -> sectionPayload=$sectionPayload');
      final Map<String, dynamic> payload = {
        'teacher_id': teacherId,
        'topic': meeting.topic,
        'start_at': startAt,
        'duration': defaultDurationMinutes,
        'section_id[]': sectionPayload,
      };
      // if (sectionPayload is int) {
      //   payload['section_id[]'] = sectionPayload; // مثال: section_id[] = 1
      // } else if (sectionPayload is List<int>) {
      //   payload['section_id[]'] = sectionPayload; // مثال: section_id[] = [1,2]
      // } else {
      //   payload['section_id'] = sectionPayload; // احتياطي
      // }

      final result = await dioClient.post(
        Constants.createZoomMeetingsEndpoint,
        data: payload,
        options: Options(contentType: Headers.formUrlEncodedContentType),
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
          if (data is! Map) {
            return const Left(ValidationFailure(message: 'تنسيق البيانات غير صحيح'));
          }
          final Map<String, dynamic> m = Map<String, dynamic>.from(data);

          // invitedClasses قد تكون كائن يحوي grade/classroom/section
          final dynamic invitedRaw = m['invitedClasses'];
          List<String> invitedClasses;
          if (invitedRaw is Map) {
            final Map<String, dynamic> ic = Map<String, dynamic>.from(invitedRaw);
            final String classroom = (ic['classroom'] ?? '').toString();
            final String section = (ic['section'] ?? '').toString();
            final String display = classroom.isNotEmpty && section.isNotEmpty
                ? '$classroom - شعبة $section'
                : (classroom.isNotEmpty ? classroom : section);
            invitedClasses = display.trim().isEmpty ? <String>[] : <String>[display];
          } else if (invitedRaw is List) {
            invitedClasses = invitedRaw.map((e) => e.toString()).toList();
          } else {
            invitedClasses = const <String>[];
          }

          // التاريخ والوقت مفصولان
          final String scheduledDateStr = (m['scheduledDate'] ?? '').toString();
          final String scheduledTimeStr = (m['scheduledTime'] ?? '').toString();

          DateTime scheduledDate;
          DateTime scheduledTime;
          try {
            scheduledDate = DateTime.parse(scheduledDateStr);
          } catch (_) {
            scheduledDate = meeting.scheduledDate;
          }
          try {
            final parts = scheduledTimeStr.split(':');
            final int hh = parts.isNotEmpty ? int.tryParse(parts[0]) ?? 0 : 0;
            final int mm = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
            final int ss = parts.length > 2 ? int.tryParse(parts[2]) ?? 0 : 0;
            scheduledTime = DateTime(
              scheduledDate.year,
              scheduledDate.month,
              scheduledDate.day,
              hh,
              mm,
              ss,
            );
          } catch (_) {
            scheduledTime = meeting.scheduledTime;
          }

          final ZoomMeetingModel model = ZoomMeetingModel(
            id: (m['id'] ?? '').toString(),
            topic: (m['topic'] ?? '').toString(),
            invitedClasses: invitedClasses,
            scheduledDate: scheduledDate,
            scheduledTime: scheduledTime,
            enableWaitingRoom: m['enableWaitingRoom'] is bool ? m['enableWaitingRoom'] as bool : meeting.enableWaitingRoom,
            recordAutomatically: m['recordAutomatically'] is bool ? m['recordAutomatically'] as bool : meeting.recordAutomatically,
            meetingUrl: m['meetingUrl']?.toString(),
            meetingId: m['meetingId']?.toString(),
            password: m['password']?.toString(),
          );

          return Right(model);
        },
      );
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getAvailableClasses() async {
    try {
      final int? teacherId = await localDataSource.getUserId();
      print('ZoomMeetingRemoteDataSource.getAvailableClasses -> teacherId=$teacherId');
      if (teacherId == null) {
        return const Left(UnAuthenticated(message: 'الرجاء تسجيل الدخول مجدداً'));
      }

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

          // تحويل العناصر إلى أسماء فصول قابلة للعرض + تخزين خريطة العرض→المعرّف
          _sectionLabelToId.clear();
          final List<String> classes = data.map((e) {
            final Map<String, dynamic> m = Map<String, dynamic>.from(e as Map);
            final String classroom = (m['classroom'] ?? '').toString();
            final String section = (m['section'] ?? '').toString();
            final dynamic idRaw = m.containsKey('id') ? m['id'] : (m.containsKey('section_id') ? m['section_id'] : null);
            int? sectionId;
            if (idRaw is int) {
              sectionId = idRaw;
            } else if (idRaw is String) {
              sectionId = int.tryParse(idRaw);
            }
            String label;
            if (classroom.isNotEmpty && section.isNotEmpty) {
              label = '$classroom - شعبة $section';
            } else {
              label = classroom.isNotEmpty ? classroom : section;
            }
            if (sectionId != null && label.trim().isNotEmpty) {
              _sectionLabelToId[label] = sectionId;
            }
            return label;
          }).where((s) => s.trim().isNotEmpty).cast<String>().toList();

          return Right(classes);
        },
      );
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
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
    try {
      final int? teacherId = await localDataSource.getUserId();
      if (teacherId == null) {
        return const Left(UnAuthenticated(message: 'الرجاء تسجيل الدخول مجدداً'));
      }

      final result = await dioClient.post(
        Constants.getZoomMeetingsEndpoint,
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

          final List<ZoomMeetingModel> meetings = data.map((e) {
            final Map<String, dynamic> m = Map<String, dynamic>.from(e as Map);
            final List<String> invited = (m['invitedClasses'] is List)
                ? List<String>.from(m['invitedClasses'] as List)
                : <String>[];

            // Parse date string like '2025-09-15'
            DateTime scheduledDate;
            try {
              scheduledDate = DateTime.parse((m['scheduledDate'] ?? '').toString());
            } catch (_) {
              scheduledDate = DateTime.now();
            }

            // 'scheduledTime' can be string HH:mm:ss or int duration
            DateTime scheduledTime;
            final dynamic st = m['scheduledTime'];
            if (st is String) {
              try {
                final parts = st.split(':');
                final int hh = parts.isNotEmpty ? int.tryParse(parts[0]) ?? 0 : 0;
                final int mm = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
                final int ss = parts.length > 2 ? int.tryParse(parts[2]) ?? 0 : 0;
                scheduledTime = DateTime(scheduledDate.year, scheduledDate.month, scheduledDate.day, hh, mm, ss);
              } catch (_) {
                scheduledTime = DateTime(scheduledDate.year, scheduledDate.month, scheduledDate.day);
              }
            } else if (st is int) {
              // treat as duration minutes; default time-of-day to 00:00
              scheduledTime = DateTime(scheduledDate.year, scheduledDate.month, scheduledDate.day);
            } else {
              scheduledTime = DateTime(scheduledDate.year, scheduledDate.month, scheduledDate.day);
            }

            return ZoomMeetingModel(
              id: (m['id'] ?? '').toString(),
              topic: (m['topic'] ?? '').toString(),
              invitedClasses: invited,
              scheduledDate: scheduledDate,
              scheduledTime: scheduledTime,
              enableWaitingRoom: m['enableWaitingRoom'] is bool ? m['enableWaitingRoom'] as bool : true,
              recordAutomatically: m['recordAutomatically'] is bool ? m['recordAutomatically'] as bool : false,
              meetingUrl: m['meetingUrl']?.toString(),
              meetingId: m['meetingId']?.toString(),
              password: m['password']?.toString(),
            );
          }).toList().cast<ZoomMeetingModel>();

          return Right(meetings);
        },
      );
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
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