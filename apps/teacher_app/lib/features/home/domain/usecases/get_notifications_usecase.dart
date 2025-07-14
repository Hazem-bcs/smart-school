import '../entities/notification_entity.dart';
import '../repositories/home_repository.dart';

class GetNotificationsUseCase {
  final HomeRepository repository;

  GetNotificationsUseCase(this.repository);

  Future<List<NotificationEntity>> call() async {
    return await repository.getNotifications();
  }
} 