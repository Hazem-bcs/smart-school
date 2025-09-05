import 'package:flutter/material.dart';
import '../../../domain/entities/notification_entity.dart';
import '../../../../../core/responsive/responsive_helper.dart';
import 'assignment_tile.dart';

class NotificationsSection extends StatelessWidget {
  final List<NotificationEntity> notifications;
  final VoidCallback? onNotificationTap;

  const NotificationsSection({
    super.key,
    required this.notifications,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context)),
          child: Text(
            'الإشعارات',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final item = notifications[index];
            return AssignmentTile(
              title: item.title,
              subtitle: item.subtitle,
              icon: Icons.notifications,
              index: index,
              onTap: onNotificationTap,
            );
          },
        ),
      ],
    );
  }
}


