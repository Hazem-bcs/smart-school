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
    // دعم شكلين من الاستجابات: النموذج القديم، ونموذج الباك-إند الحالي
    final dynamic sessionId = json['sessionId'] ?? json['id'];
    final String id = sessionId?.toString() ?? '';
    final String topic = (json['topic'] ?? '').toString();

    // startAt بصيغة 'YYYY-MM-DD HH:MM' → نحاول تحويلها بأمان
    DateTime parsedDateTime;
    final String? startAt = json['startAt']?.toString();
    final String? dateTimeIso = json['dateTime']?.toString();
    if (startAt != null && startAt.isNotEmpty) {
      parsedDateTime = _parseDateTimeFlexible(startAt);
    } else if (dateTimeIso != null && dateTimeIso.isNotEmpty) {
      parsedDateTime = _parseDateTimeFlexible(dateTimeIso);
    } else {
      parsedDateTime = DateTime.now();
    }

    final String joinUrl = (json['joinUrl'] ?? json['zoomLink'] ?? '').toString();

    return ZoomMeetingModel(
      id: id,
      topic: topic,
      className: (json['className'] ?? '').toString(),
      teacher: (json['teacher'] ?? '').toString(),
      dateTime: parsedDateTime,
      zoomLink: joinUrl,
      isLive: (json['isLive'] as bool?) ?? false,
    );
  }

  static DateTime _parseDateTimeFlexible(String value) {
    try {
      // يحاول DateTime.parse أولاً
      return DateTime.parse(value.replaceAll('/', '-'));
    } catch (_) {
      // نحاول تنسيق "yyyy-MM-dd HH:mm"
      try {
        final parts = value.split(' ');
        final datePart = parts.isNotEmpty ? parts[0] : '';
        final timePart = parts.length > 1 ? parts[1] : '00:00';
        final datePieces = datePart.split('-');
        final timePieces = timePart.split(':');
        final int y = int.tryParse(datePieces[0]) ?? 1970;
        final int m = int.tryParse(datePieces.length > 1 ? datePieces[1] : '1') ?? 1;
        final int d = int.tryParse(datePieces.length > 2 ? datePieces[2] : '1') ?? 1;
        final int hh = int.tryParse(timePieces[0]) ?? 0;
        final int mm = int.tryParse(timePieces.length > 1 ? timePieces[1] : '0') ?? 0;
        final int ss = int.tryParse(timePieces.length > 2 ? timePieces[2] : '0') ?? 0;
        return DateTime(y, m, d, hh, mm, ss);
      } catch (e) {
        return DateTime.now();
      }
    }
  }

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