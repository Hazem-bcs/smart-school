import 'package:equatable/equatable.dart';

class ZoomMeetingEntity extends Equatable {
  final String id;
  final String topic;
  final List<String> invitedClasses;
  final DateTime scheduledDate;
  final DateTime scheduledTime;
  final bool enableWaitingRoom;
  final bool recordAutomatically;
  final String? meetingUrl;
  final String? meetingId;
  final String? password;

  const ZoomMeetingEntity({
    required this.id,
    required this.topic,
    required this.invitedClasses,
    required this.scheduledDate,
    required this.scheduledTime,
    this.enableWaitingRoom = true,
    this.recordAutomatically = false,
    this.meetingUrl,
    this.meetingId,
    this.password,
  });

  @override
  List<Object?> get props => [
    id, 
    topic, 
    invitedClasses, 
    scheduledDate, 
    scheduledTime, 
    enableWaitingRoom, 
    recordAutomatically, 
    meetingUrl, 
    meetingId, 
    password
  ];
} 