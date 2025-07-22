

import '../../domain/entities/zoom_meeting.dart';

class ZoomMeetingModel extends ZoomMeeting {
  ZoomMeetingModel({
    required super.id,
    required super.topic,
    required super.className,
    required super.teacher,
    required super.dateTime,
    required super.zoomLink,
    super.isLive,
  });

  factory ZoomMeetingModel.fromJson(Map<String, dynamic> json) {
    return ZoomMeetingModel(
      id: json['id'] as String,
      topic: json['topic'] as String,
      className: json['className'] as String,
      teacher: json['teacher'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
      zoomLink: json['zoomLink'] as String,
      isLive: json['isLive'] as bool? ?? false, // إذا كانت isLive غير موجودة، تكون القيمة الافتراضية false
    );
  }

  // يمكن إضافة تابع لتحويل Model إلى Entity إذا كانت هناك حاجة لمعالجة إضافية قبل العرض
  ZoomMeeting toEntity() {
    return ZoomMeeting(
      id: id,
      topic: topic,
      className: className,
      teacher: teacher,
      dateTime: dateTime,
      zoomLink: zoomLink,
      isLive: isLive,
    );
  }
}