import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:notification/domain/entities/notification_entity.dart';
import 'package:notification/domain/use_cases/get_notification_list_use_case.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotificationListUseCase getNotificationListUseCase;
  NotificationBloc({required this.getNotificationListUseCase}) : super(NotificationInitial()) {
    on<GetNotificationListEvent>(_onGetNotificationList);
    on<UpdateNotificationEvent>(_onUpdateNotification);
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



}
