class ZoomMeeting {
  final String id;
  final String topic;
  final String className;
  final String teacher;
  final DateTime dateTime;
  final String zoomLink;
  final bool isLive;

  ZoomMeeting({
    required this.id,
    required this.topic,
    required this.className,
    required this.teacher,
    required this.dateTime,
    required this.zoomLink,
    this.isLive = false,
  });
}
