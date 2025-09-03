import 'package:flutter/material.dart';
import 'package:notification/domain/entities/notification_entity.dart';
import 'package:core/theme/constants/app_spacing.dart';
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
            child: NotificationCard(
              notification: notification,
              onTap: () => onNotificationTap(notification),
            ),
          );
        },
      ),
    );
  }
}
