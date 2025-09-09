import 'package:core/theme/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notification/domain/entities/notification_entity.dart';
import 'package:smart_school/widgets/app_bar_widget.dart';

import '../widgets/index.dart';
import '../bloc/notification_bloc.dart';

/// Main notification page that displays all notifications
class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() {
    context.read<NotificationBloc>().add(GetNotificationListEvent());
  }

  void _markAsRead(NotificationEntity notification) {
    context.read<NotificationBloc>().add(MarkAsReadEvent(id: notification.id));
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppStrings.markAsRead.replaceAll('%s', notification.title),
        ),
      ),
    );
  }

  void _onNotificationTap(NotificationEntity notification) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppStrings.notificationTapped.replaceAll('%s', notification.title),
        ),
      ),
    );
    
    if (!notification.isRead) {
      _markAsRead(notification);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: AppStrings.notification,
        actions: [
          AppBarActions.refresh(
            onPressed: _loadNotifications,
            isDark: Theme.of(context).brightness == Brightness.dark,
          ),
          IconButton(
            tooltip: 'وضع علامة الكل كمقروء',
            onPressed: () => context.read<NotificationBloc>().add(MarkAllAsReadEvent()),
            icon: const Icon(Icons.done_all),
          ),
          IconButton(
            tooltip: 'حذف الكل',
            onPressed: () => context.read<NotificationBloc>().add(ClearNotificationsEvent()),
            icon: const Icon(Icons.delete_sweep),
          ),
        ],
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          return _buildBody(state);
        },
      ),
    );
  }

  Widget _buildBody(NotificationState state) {
    if (state is NotificationInitial || state is NotificationLoadingState) {
      return const NotificationLoadingWidget();
    } else if (state is NotificationErrorState) {
      return NotificationErrorWidget(
        errorMessage: state.message,
        onRetry: _loadNotifications,
      );
    } else if (state is NotificationListLoadedState) {
      final notifications = state.notificationList;

      if (notifications.isEmpty) {
        return NotificationEmptyWidget(
          onRefresh: _loadNotifications,
        );
      }

      return NotificationListWidget(
        notifications: notifications,
        onRefresh: _loadNotifications,
        onNotificationTap: _onNotificationTap,
      );
    }
    
    return const SizedBox.shrink();
  }
}