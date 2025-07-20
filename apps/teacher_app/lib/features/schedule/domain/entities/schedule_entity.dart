import 'package:equatable/equatable.dart';

class ScheduleEntity extends Equatable {
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

  const ScheduleEntity({
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

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    startTime,
    endTime,
    className,
    subject,
    teacherId,
    location,
    type,
    status,
  ];
}

enum ScheduleType {
  classType,
  meeting,
  exam,
  event,
  breakTime,
}

enum ScheduleStatus {
  upcoming,
  completed,
  ongoing,
} 