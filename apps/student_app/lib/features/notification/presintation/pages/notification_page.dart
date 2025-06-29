import 'package:core/theme/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notification/domain/entities/notification_entity.dart';
import 'package:smart_school/widgets/app_bar_widget.dart';

import '../widgets/notification_card.dart';
import '../bloc/notification_bloc.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationBloc>().add(GetNotificationListEvent());
  }

  void _markAsRead(NotificationEntity notification) {
    context.read<NotificationBloc>().add(
      UpdateNotificationEvent(
        updatedNotification: notification.copyWith(isRead: true),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم تحديد "${notification.title}" كمقروءة')),
    );
  }

  void _onNotificationTap(NotificationEntity notification) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('نقر على الإشعار: ${notification.title}')),
    );
    if (!notification.isRead) {
      _markAsRead(notification);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title:AppStrings.notification),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationInitial || state is NotificationLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NotificationErrorState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 80, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'خطأ في تحميل الإشعارات:\n${state.message}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<NotificationBloc>().add(GetNotificationListEvent());
                    },
                    child: const Text('retry'),
                  ),
                ],
              ),
            );
          } else if (state is NotificationListLoadedState) {
            final notifications = state.notificationList;

            if (notifications.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.notifications_off, size: 80, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'لا توجد إشعارات حالياً',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }
            notifications.sort((a, b) => b.sentTime.compareTo(a.sentTime));
            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return NotificationCard(
                  notification: notification,
                  onTap: () => _onNotificationTap(notification),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}