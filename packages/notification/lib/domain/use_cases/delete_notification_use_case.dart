import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';

import '../notification_repositoty.dart';

class DeleteNotificationUseCase {
  final NotificationRepository repository;

  DeleteNotificationUseCase(this.repository);

  Future<Either<Failure, Unit>> call(String id) async {
    return await repository.deleteNotification(id);
  }
}


