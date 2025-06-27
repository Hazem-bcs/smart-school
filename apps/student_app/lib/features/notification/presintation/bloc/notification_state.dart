part of 'notification_bloc.dart';

@immutable
sealed class NotificationState {}

final class NotificationInitial extends NotificationState {}

final class NotificationLoadingState extends NotificationState {}

final class NotificationListLoadedState extends NotificationState {
  final List<NotificationEntity> notificationList;

  NotificationListLoadedState({required this.notificationList});
}

final class NotificationErrorState extends NotificationState {
  final String message;

  NotificationErrorState({required this.message});
}