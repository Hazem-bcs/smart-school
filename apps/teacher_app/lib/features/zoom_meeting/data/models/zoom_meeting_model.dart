import '../../domain/entities/zoom_meeting_entity.dart';

class ZoomMeetingModel {
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

  const ZoomMeetingModel({
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

  factory ZoomMeetingModel.fromJson(Map<String, dynamic> json) {
    return ZoomMeetingModel(
      id: json['id'] ?? '',
      topic: json['topic'] ?? '',
      invitedClasses: List<String>.from(json['invitedClasses'] ?? []),
      scheduledDate: DateTime.parse(json['scheduledDate'] ?? DateTime.now().toIso8601String()),
      scheduledTime: DateTime.parse(json['scheduledTime'] ?? DateTime.now().toIso8601String()),
      enableWaitingRoom: json['enableWaitingRoom'] ?? true,
      recordAutomatically: json['recordAutomatically'] ?? false,
      meetingUrl: json['meetingUrl'],
      meetingId: json['meetingId'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'topic': topic,
      'invitedClasses': invitedClasses,
      'scheduledDate': scheduledDate.toIso8601String(),
      'scheduledTime': scheduledTime.toIso8601String(),
      'enableWaitingRoom': enableWaitingRoom,
      'recordAutomatically': recordAutomatically,
      'meetingUrl': meetingUrl,
      'meetingId': meetingId,
      'password': password,
    };
  }

  ZoomMeetingEntity toEntity() => ZoomMeetingEntity(
    id: id,
    topic: topic,
    invitedClasses: invitedClasses,
    scheduledDate: scheduledDate,
    scheduledTime: scheduledTime,
    enableWaitingRoom: enableWaitingRoom,
    recordAutomatically: recordAutomatically,
    meetingUrl: meetingUrl,
    meetingId: meetingId,
    password: password,
  );

  factory ZoomMeetingModel.fromEntity(ZoomMeetingEntity entity) => ZoomMeetingModel(
    id: entity.id,
    topic: entity.topic,
    invitedClasses: entity.invitedClasses,
    scheduledDate: entity.scheduledDate,
    scheduledTime: entity.scheduledTime,
    enableWaitingRoom: entity.enableWaitingRoom,
    recordAutomatically: entity.recordAutomatically,
    meetingUrl: entity.meetingUrl,
    meetingId: entity.meetingId,
    password: entity.password,
  );
}