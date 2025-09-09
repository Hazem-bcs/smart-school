import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:notification/domain/entities/notification_entity.dart';
import 'package:notification/domain/use_cases/get_notification_list_use_case.dart';
import 'package:notification/domain/use_cases/add_notification_use_case.dart';
import 'package:notification/domain/use_cases/mark_as_read_use_case.dart';
import 'package:notification/domain/use_cases/delete_notification_use_case.dart';
import 'package:notification/domain/use_cases/clear_notifications_use_case.dart';
import 'package:notification/domain/use_cases/mark_all_as_read_use_case.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotificationListUseCase getNotificationListUseCase;
  final AddNotificationUseCase addNotificationUseCase;
  final MarkAsReadUseCase markAsReadUseCase;
  final DeleteNotificationUseCase deleteNotificationUseCase;
  final ClearNotificationsUseCase clearNotificationsUseCase;
  final MarkAllAsReadUseCase markAllAsReadUseCase;

  NotificationBloc({
    required this.getNotificationListUseCase,
    required this.addNotificationUseCase,
    required this.markAsReadUseCase,
    required this.deleteNotificationUseCase,
    required this.clearNotificationsUseCase,
    required this.markAllAsReadUseCase,
  }) : super(NotificationInitial()) {
    on<GetNotificationListEvent>(_onGetNotificationList);
    on<UpdateNotificationEvent>(_onUpdateNotification);
    on<AddNotificationEvent>(_onAddNotification);
    on<MarkAsReadEvent>(_onMarkAsRead);
    on<DeleteNotificationEvent>(_onDeleteNotification);
    on<ClearNotificationsEvent>(_onClearNotifications);
    on<MarkAllAsReadEvent>(_onMarkAllAsRead);
  }

  Future<void> _onGetNotificationList(GetNotificationListEvent event , Emitter<NotificationState> emit) async {
   emit(NotificationLoadingState());
   final result = await getNotificationListUseCase();
   result.fold(
     (failure) => emit(NotificationErrorState(message: failure.message)),
     (notificationList) => emit(NotificationListLoadedState(notificationList: notificationList)),
   );
  }


  void _onUpdateNotification(UpdateNotificationEvent event, Emitter<NotificationState> emit) {
    if (state is NotificationListLoadedState) {
      final currentList = List<NotificationEntity>.from((state as NotificationListLoadedState).notificationList);
      final index = currentList.indexWhere((n) => n.id == event.updatedNotification.id);

      if (index != -1) {
        currentList[index] = event.updatedNotification;
        emit(NotificationListLoadedState(notificationList: currentList));
      }
    }
  }

  Future<void> _onAddNotification(AddNotificationEvent event, Emitter<NotificationState> emit) async {
    final result = await addNotificationUseCase(event.notification);
    result.fold(
      (failure) {
        // keep UI unchanged on failure
      },
      (_) {
        if (state is NotificationListLoadedState) {
          final current = List<NotificationEntity>.from((state as NotificationListLoadedState).notificationList);
          final index = current.indexWhere((n) => n.id == event.notification.id);
          if (index >= 0) {
            current[index] = event.notification;
          } else {
            current.add(event.notification);
          }
          current.sort((a, b) => b.sentTime.compareTo(a.sentTime));
          emit(NotificationListLoadedState(notificationList: current));
        }
      },
    );
  }

  Future<void> _onMarkAsRead(MarkAsReadEvent event, Emitter<NotificationState> emit) async {
    final result = await markAsReadUseCase(event.id);
    result.fold(
      (failure) {
        // ignore
      },
      (_) {
        if (state is NotificationListLoadedState) {
          final list = List<NotificationEntity>.from((state as NotificationListLoadedState).notificationList);
          final idx = list.indexWhere((e) => e.id == event.id);
          if (idx >= 0) {
            list[idx] = list[idx].copyWith(isRead: true);
            emit(NotificationListLoadedState(notificationList: list));
          }
        }
      },
    );
  }

  Future<void> _onDeleteNotification(DeleteNotificationEvent event, Emitter<NotificationState> emit) async {
    final result = await deleteNotificationUseCase(event.id);
    result.fold(
      (failure) {
        // ignore
      },
      (_) {
        if (state is NotificationListLoadedState) {
          final list = List<NotificationEntity>.from((state as NotificationListLoadedState).notificationList)
            ..removeWhere((e) => e.id == event.id);
          emit(NotificationListLoadedState(notificationList: list));
        }
      },
    );
  }

  Future<void> _onClearNotifications(ClearNotificationsEvent event, Emitter<NotificationState> emit) async {
    final result = await clearNotificationsUseCase();
    result.fold(
      (failure) {
        // ignore
      },
      (_) => emit(NotificationListLoadedState(notificationList: [])),
    );
  }

  Future<void> _onMarkAllAsRead(MarkAllAsReadEvent event, Emitter<NotificationState> emit) async {
    final result = await markAllAsReadUseCase();
    result.fold(
      (failure) {
        // ignore
      },
      (_) {
        if (state is NotificationListLoadedState) {
          final list = (state as NotificationListLoadedState)
              .notificationList
              .map((e) => e.copyWith(isRead: true))
              .toList();
          emit(NotificationListLoadedState(notificationList: list));
        }
      },
    );
  }



}
