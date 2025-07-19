import '../../domain/entities/schedule_entity.dart';

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
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      startTime: DateTime.parse(json['startTime'] ?? DateTime.now().toIso8601String()),
      endTime: DateTime.parse(json['endTime'] ?? DateTime.now().toIso8601String()),
      className: json['className'] ?? '',
      subject: json['subject'] ?? '',
      teacherId: json['teacherId'] ?? '',
      location: json['location'] ?? '',
      type: _parseScheduleType(json['type'] ?? 'class'),
      status: _parseScheduleStatus(json['status'] ?? 'scheduled'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'className': className,
      'subject': subject,
      'teacherId': teacherId,
      'location': location,
      'type': type.toString().split('.').last,
      'status': status.toString().split('.').last,
    };
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