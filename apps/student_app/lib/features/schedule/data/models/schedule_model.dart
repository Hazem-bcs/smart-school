import '../../domain/entities/schedule_entity.dart';
import 'package:intl/intl.dart';

class ScheduleModel extends ScheduleEntity {
  ScheduleModel({
    required super.id,
    required super.title,
    required super.description,
    required super.startTime,
    required super.endTime,
    required super.className,
    required super.subject,
    required super.teacherId,
    required super.location,
    required super.type,
    required super.status,
  });
  

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: (json['description'] ?? '').toString(),
      startTime: _parseDateTime(json['startTime'] ?? json['start_time']),
      endTime: _parseDateTime(json['endTime'] ?? json['end_time']),
      className: json['className']?.toString() ?? json['class_name']?.toString() ?? '',
      subject: json['subject']?.toString() ?? '',
      teacherId: json['teacherId']?.toString() ?? json['teacher_id']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      type: _parseScheduleType((json['type'] ?? 'class').toString()),
      status: _parseScheduleStatus((json['status'] ?? 'upcoming').toString()),
    );
  }

  static ScheduleType _parseScheduleType(String type) {
    switch (type) {
      case 'class':
        return ScheduleType.classType;
      case 'meeting':
        return ScheduleType.meeting;
      case 'exam':
        return ScheduleType.exam;
      case 'event':
        return ScheduleType.event;
      case 'break':
        return ScheduleType.breakTime;
      default:
        return ScheduleType.classType;
    }
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is DateTime) return value;
    final str = value.toString();
    try {
      return DateTime.parse(str);
    } catch (_) {
      try {
        return DateFormat("yyyy-MM-dd'T'HH:mm:ssZ").parse(str, true).toLocal();
      } catch (_) {
        return DateTime.now();
      }
    }
  }

  static ScheduleStatus _parseScheduleStatus(String status) {
    switch (status) {
      case 'scheduled':
      case 'upcoming':
        return ScheduleStatus.upcoming;
      case 'inProgress':
      case 'ongoing':
        return ScheduleStatus.ongoing;
      case 'completed':
        return ScheduleStatus.completed;
      case 'cancelled':
        return ScheduleStatus.completed; // Treat cancelled as completed
      default:
        return ScheduleStatus.upcoming;
    }
  }
} 