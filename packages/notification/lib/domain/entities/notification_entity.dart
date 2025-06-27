class NotificationEntity {
  final String id;
  final String title;
  final String body;
  final DateTime sentTime;
  final bool isRead;
  final String? imageUrl;
  final String? deepLink;

  NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.sentTime,
    required this.isRead,
    this.imageUrl,
    this.deepLink,
  });
}