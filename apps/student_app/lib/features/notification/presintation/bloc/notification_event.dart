part of 'notification_bloc.dart';

@immutable
sealed class NotificationEvent {}

class GetNotificationListEvent extends NotificationEvent {}


class UpdateNotificationEvent extends NotificationEvent {
  final NotificationEntity updatedNotification;

  UpdateNotificationEvent({required this.updatedNotification});

}

