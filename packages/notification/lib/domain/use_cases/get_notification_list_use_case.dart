import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';

import '../entities/notification_entity.dart';
import '../notification_repositoty.dart';

class GetNotificationListUseCase {
  final NotificationRepository repository;

  GetNotificationListUseCase(this.repository);

  Future<Either<Failure,List<NotificationEntity>>> call() async {
    return await repository.getNotificationList();
  }
}