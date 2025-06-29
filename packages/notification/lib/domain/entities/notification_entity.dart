import 'package:flutter/foundation.dart';


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



  NotificationEntity copyWith({
    String? id,
    String? title,
    String? body,
    DateTime? sentTime,
    bool? isRead,
    ValueGetter<String?>? imageUrl, // استخدم ValueGetter لتمكين تعيين قيمة null صراحةً
    ValueGetter<String?>? deepLink,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      sentTime: sentTime ?? this.sentTime,
      isRead: isRead ?? this.isRead,
      imageUrl: imageUrl != null ? imageUrl() : this.imageUrl, // استخدام ValueGetter
      deepLink: deepLink != null ? deepLink() : this.deepLink, // استخدام ValueGetter
    );
  }

}