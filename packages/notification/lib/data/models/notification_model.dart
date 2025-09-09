import '../../domain/entities/notification_entity.dart';

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final DateTime sentTime;
  final bool isRead;
  final String? imageUrl;
  final String? deepLink;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.sentTime,
    required this.isRead,
    this.imageUrl,
    this.deepLink,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      sentTime: DateTime.parse(json['sentTime'] as String),
      isRead: json['isRead'] as bool,
      imageUrl: json['imageUrl'] as String?,
      deepLink: json['deepLink'] as String?,
    );
  }

  NotificationEntity toEntity() {
    return NotificationEntity(
      id: id,
      title: title,
      body: body,
      sentTime: sentTime,
      isRead: isRead,
      imageUrl: imageUrl,
      deepLink: deepLink,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'sentTime': sentTime.toIso8601String(),
      'isRead': isRead,
      'imageUrl': imageUrl,
      'deepLink': deepLink,
    };
  }

  factory NotificationModel.fromEntity(NotificationEntity entity) {
    return NotificationModel(
      id: entity.id,
      title: entity.title,
      body: entity.body,
      sentTime: entity.sentTime,
      isRead: entity.isRead,
      imageUrl: entity.imageUrl,
      deepLink: entity.deepLink,
    );
  }
}
