import '../../domain/entities/schedule_entity.dart';

class ScheduleModel {
  final String id;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final String className;
  final String subject;
  final String teacherId;
  final String location;
  final ScheduleType type;
  final ScheduleStatus status;

  const ScheduleModel({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.className,
    required this.subject,
    required this.teacherId,
    required this.location,
    required this.type,
    required this.status,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json['id'] != null ? json['id'].toString() : '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      startTime: DateTime.parse(json['startTime'] ?? DateTime.now().toIso8601String()),
      endTime: DateTime.parse(json['endTime'] ?? DateTime.now().toIso8601String()),
      className: json['className'] ?? _composeClassName(
        grade: json['grade']?.toString(),
        classroom: json['classroom']?.toString(),
        section: json['section']?.toString(),
      ),
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

  ScheduleEntity toEntity() => ScheduleEntity(
    id: id,
    title: title,
    description: description,
    startTime: startTime,
    endTime: endTime,
    className: className,
    subject: subject,
    teacherId: teacherId,
    location: location,
    type: type,
    status: status,
  );

  factory ScheduleModel.fromEntity(ScheduleEntity entity) => ScheduleModel(
    id: entity.id,
    title: entity.title,
    description: entity.description,
    startTime: entity.startTime,
    endTime: entity.endTime,
    className: entity.className,
    subject: entity.subject,
    teacherId: entity.teacherId,
    location: entity.location,
    type: entity.type,
    status: entity.status,
  );

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
      case 'holiday':
        return ScheduleType.holiday;
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

  static String _composeClassName({String? grade, String? classroom, String? section}) {
    final parts = <String>[];
    if (grade != null && grade.trim().isNotEmpty) parts.add(grade.trim());
    if (classroom != null && classroom.trim().isNotEmpty) parts.add(classroom.trim());
    if (section != null && section.trim().isNotEmpty) parts.add(section.trim());
    return parts.join(' ').trim();
  }
} 