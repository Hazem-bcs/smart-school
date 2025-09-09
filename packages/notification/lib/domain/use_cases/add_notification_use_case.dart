import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';

import '../entities/notification_entity.dart';
import '../notification_repositoty.dart';

class AddNotificationUseCase {
  final NotificationRepository repository;

  AddNotificationUseCase(this.repository);

  Future<Either<Failure, Unit>> call(NotificationEntity notification) async {
    return await repository.addNotification(notification);
  }
}


