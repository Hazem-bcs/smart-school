import 'package:core/theme/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notification/domain/entities/notification_entity.dart';



class NotificationCard extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback? onTap;


  const NotificationCard({
    Key? key,
    required this.notification,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: notification.isRead ? 0.5 : 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      color: notification.isRead ? Colors.grey[100] : Colors.white,
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
                    backgroundColor: notification.isRead
                        ? theme.disabledColor
                        : theme.primaryColor.withOpacity(0.1),
                    child: Icon(
                      notification.isRead
                          ? Icons.notifications_none
                          : Icons.notifications_active,
                      color: notification.isRead
                          ? theme.hintColor
                          : primaryColor,
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
                            fontWeight: notification.isRead
                                ? FontWeight.normal
                                : FontWeight.bold,
                            color: notification.isRead
                                ? theme.textTheme.bodySmall?.color
                                : theme.textTheme.bodyLarge?.color,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          notification.body,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: notification.isRead
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
                            DateFormat('MMM dd, yyyy - hh:mm a')
                                .format(notification.sentTime),
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
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 150,
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: const Icon(Icons.broken_image, color: Colors.grey),
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