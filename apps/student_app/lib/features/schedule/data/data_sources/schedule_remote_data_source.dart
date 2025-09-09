import 'dart:convert';

import 'package:core/constant.dart';
import 'package:core/network/dio_client.dart';
import 'package:core/network/failures.dart';

import '../models/schedule_model.dart';

abstract class ScheduleRemoteDataSource {
  Future<List<ScheduleModel>> getScheduleForDate(DateTime date,int studentId);
}

class ScheduleRemoteDataSourceImpl implements ScheduleRemoteDataSource {
  final DioClient dioClient;

  ScheduleRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<ScheduleModel>> getScheduleForDate(DateTime date,int studentId) async {
    try {
      final String formattedDate = date.toIso8601String().split('T').first;
      final responseEither = await dioClient.post(
        Constants.getStudentScheduleForDateEndpoint,
        data: {
          'date': formattedDate,
          'student_id': studentId,
        },
      );

      return responseEither.fold((failure) {
        throw Exception(_failureMessage(failure));
      }, (response) {
        final dynamic data = response.data;
        List<dynamic> items;
        if (data is Map<String, dynamic>) {
          final dynamic wrapped = data['data'];
          if (wrapped is List) {
            items = wrapped;
          } else if (wrapped is Map<String, dynamic>) {
            final dynamic inner = wrapped['items'];
            items = inner is List ? inner : [];
          } else {
            items = [];
          }
        } else if (data is List) {
          items = data;
        } else if (data is String) {
          // Some endpoints might return a JSON string
          try {
            final decoded = data as dynamic;
            if (decoded is String) {
              // ignore: avoid_dynamic_calls
              final Map<String, dynamic> map = jsonDecode(decoded) as Map<String, dynamic>;
              final dynamic wrapped = map['data'];
              if (wrapped is List) {
                items = wrapped;
              } else if (wrapped is Map<String, dynamic>) {
                final dynamic inner = wrapped['items'];
                items = inner is List ? inner : [];
              } else {
                items = [];
              }
            } else {
              items = [];
            }
          } catch (_) {
            items = [];
          }
        } else {
          items = [];
        }

        final models = items
            .whereType<Map<String, dynamic>>()
            .map((e) => ScheduleModel.fromJson(_normalizeBackendItem(e)))
            .toList();
        return models;
      });
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> _normalizeBackendItem(Map<String, dynamic> raw) {
    return {
      'id': raw['id']?.toString() ?? '',
      'title': raw['title'] ?? raw['subject'] ?? '',
      'description': raw['description']?.toString() ?? '',
      'startTime': raw['startTime'] ?? raw['start_time'] ?? DateTime.now().toIso8601String(),
      'endTime': raw['endTime'] ?? raw['end_time'] ?? DateTime.now().toIso8601String(),
      'className': raw['className'] ?? raw['class_name'] ?? '',
      'subject': raw['subject'] ?? raw['title'] ?? '',
      'teacherId': raw['teacherId']?.toString() ?? raw['teacher_id']?.toString() ?? '',
      'location': raw['location']?.toString() ?? '',
      // Default values when backend does not provide these
      'type': raw['type'] ?? 'class',
      'status': raw['status'] ?? 'upcoming',
    };
  }

  String _failureMessage(Failure failure) {
    return failure.message;
  }
} 