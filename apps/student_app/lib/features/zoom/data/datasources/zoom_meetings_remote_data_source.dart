import 'dart:convert';

import 'package:core/constant.dart';
import 'package:core/network/dio_client.dart';
import 'package:dio/dio.dart' show DioException, DioExceptionType, RequestOptions, Response;
import '../../data/models/zoom_meeting_model.dart';
import 'package:smart_school/features/settings/data/datasources/settings_local_data_source.dart';

abstract class ZoomMeetingsRemoteDataSource {
  Future<List<ZoomMeetingModel>> getAllZoomMeetings();
}

class ZoomMeetingsRemoteDataSourceImpl implements ZoomMeetingsRemoteDataSource {
  final DioClient dioClient;
  final SettingsLocalDataSource localDataSource;

  ZoomMeetingsRemoteDataSourceImpl({required this.dioClient, required this.localDataSource});

  @override
  Future<List<ZoomMeetingModel>> getAllZoomMeetings() async {
    try {
      final int? studentId = await localDataSource.getId();
      if (studentId == null) {
        // تصرّف كمصادقة مفقودة ليتعامل معها المستودع بشكل صحيح
        throw DioException(
          requestOptions: RequestOptions(path: Constants.getStudentZoom),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: Constants.getStudentZoom),
            statusCode: 401,
            data: {'message': 'غير مصرح. الرجاء تسجيل الدخول مجدداً'},
          ),
        );
      }
      final responseEither = await dioClient.post(
        Constants.getStudentZoom,
        data: {
          'student_id': studentId,
        },
      );

      return responseEither.fold((failure) {
        // مرر رسالة واضحة عبر DioException ليتم تحويلها في المستودع إلى Failure مناسب
        throw DioException(
          requestOptions: RequestOptions(path: Constants.getStudentZoom),
          type: DioExceptionType.unknown,
          response: Response(
            requestOptions: RequestOptions(path: Constants.getStudentZoom),
            statusCode: 500,
            data: {'message': failure.message},
          ),
        );
      }, (response) {
        final dynamic data = response.data;
        List<dynamic> items;

        if (data is Map<String, dynamic>) {
          final int status = data['status'] is int ? data['status'] as int : 500;
          if (status != 200) {
            final String message = data['message']?.toString() ?? 'حدث خطأ في الخادم';
            throw DioException(
              requestOptions: RequestOptions(path: Constants.getStudentZoom),
              type: DioExceptionType.badResponse,
              response: Response(
                requestOptions: RequestOptions(path: Constants.getStudentZoom),
                statusCode: status,
                data: {'message': message},
              ),
            );
          }
          final dynamic wrapped = data['data'];
          if (wrapped is List) {
            items = wrapped;
          } else if (wrapped is String) {
            try {
              final dynamic decoded = jsonDecode(wrapped);
              items = decoded is List ? decoded : <dynamic>[];
            } catch (_) {
              items = <dynamic>[];
            }
          } else {
            items = <dynamic>[];
          }
        } else if (data is String) {
          try {
            final Map<String, dynamic> map = jsonDecode(data) as Map<String, dynamic>;
            final dynamic wrapped = map['data'];
            items = wrapped is List ? wrapped : <dynamic>[];
          } catch (_) {
            items = <dynamic>[];
          }
        } else if (data is List) {
          items = data;
        } else {
          items = <dynamic>[];
        }

        return items
            .whereType<Map<String, dynamic>>()
            .map((e) => ZoomMeetingModel.fromJson(e))
            .toList();
      });
    } catch (e) {
      rethrow;
    }
  }
}
