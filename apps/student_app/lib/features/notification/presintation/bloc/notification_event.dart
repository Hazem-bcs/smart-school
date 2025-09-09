part of 'notification_bloc.dart';

@immutable
sealed class NotificationEvent {}

class GetNotificationListEvent extends NotificationEvent {}


class UpdateNotificationEvent extends NotificationEvent {
  final NotificationEntity updatedNotification;

  UpdateNotificationEvent({required this.updatedNotification});

}

class AddNotificationEvent extends NotificationEvent {
  final NotificationEntity notification;

  AddNotificationEvent({required this.notification});
}

class MarkAsReadEvent extends NotificationEvent {
  final String id;

  MarkAsReadEvent({required this.id});
}

class DeleteNotificationEvent extends NotificationEvent {
  final String id;

  DeleteNotificationEvent({required this.id});
}

class ClearNotificationsEvent extends NotificationEvent {}

class MarkAllAsReadEvent extends NotificationEvent {}

