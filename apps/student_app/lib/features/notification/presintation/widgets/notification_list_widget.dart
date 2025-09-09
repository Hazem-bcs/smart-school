import 'package:flutter/material.dart';
import 'package:notification/domain/entities/notification_entity.dart';
import 'package:core/theme/constants/app_spacing.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/notification_bloc.dart';
import 'notification_card.dart';

/// Widget for displaying list of notifications
class NotificationListWidget extends StatelessWidget {
  final List<NotificationEntity> notifications;
  final VoidCallback onRefresh;
  final Function(NotificationEntity) onNotificationTap;

  const NotificationListWidget({
    Key? key,
    required this.notifications,
    required this.onRefresh,
    required this.onNotificationTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sort notifications by sent time (newest first)
    final sortedNotifications = List<NotificationEntity>.from(notifications)
      ..sort((a, b) => b.sentTime.compareTo(a.sentTime));

    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: ListView.builder(
        padding: AppSpacing.screenPadding,
        itemCount: sortedNotifications.length,
        itemBuilder: (context, index) {
          final notification = sortedNotifications[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Dismissible(
              key: ValueKey(notification.id),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
                color: Colors.redAccent,
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (_) {
                context.read<NotificationBloc>().add(DeleteNotificationEvent(id: notification.id));
              },
              child: NotificationCard(
                notification: notification,
                onTap: () => onNotificationTap(notification),
              ),
            ),
          );
        },
      ),
    );
  }
}
