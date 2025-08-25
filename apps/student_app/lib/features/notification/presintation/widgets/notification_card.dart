import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notification/domain/entities/notification_entity.dart';

class NotificationCard extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback? onTap;

  const NotificationCard({Key? key, required this.notification, this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardColor =
        notification.isRead
            ? (isDark
                ? theme.colorScheme.surface.withOpacity(0.5)
                : theme.cardColor)
            : (isDark ? theme.cardColor : theme.colorScheme.background);

    final iconColor =
        notification.isRead
            ? (isDark ? theme.hintColor : theme.disabledColor)
            : theme.colorScheme.primary;

    final iconBackgroundColor =
        notification.isRead
            ? (isDark ? theme.colorScheme.surface : theme.disabledColor)
            : theme.colorScheme.primary.withOpacity(0.1);

    final titleColor =
        notification.isRead
            ? (isDark ? Colors.grey : theme.textTheme.bodySmall?.color)
            : theme.textTheme.titleMedium?.color;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: notification.isRead ? 0.5 : 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      color: cardColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: iconBackgroundColor,
                    child: Icon(
                      notification.isRead
                          ? Icons.notifications_none
                          : Icons.notifications_active,
                      color: iconColor,
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight:
                                notification.isRead
                                    ? FontWeight.normal
                                    : FontWeight.bold,
                            color: titleColor,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          notification.body,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color:
                                notification.isRead
                                    ? theme.hintColor
                                    : theme.textTheme.bodyMedium?.color,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8.0),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            DateFormat(
                              'MMM dd, yyyy - hh:mm a',
                            ).format(notification.sentTime),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.hintColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (notification.imageUrl != null) ...[
                const SizedBox(height: 12.0),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    notification.imageUrl!,
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                    errorBuilder:
                        (context, error, stackTrace) => Container(
                          height: 150,
                          width: double.infinity,
                          color: isDark ? theme.dividerColor : Colors.grey[200],
                          child: Icon(
                            Icons.broken_image,
                            color: isDark ? theme.hintColor : Colors.grey,
                          ),
                        ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
