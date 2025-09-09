import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';

import 'entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<Either<Failure,List<NotificationEntity>>> getNotificationList();

  Future<Either<Failure, Unit>> addNotification(NotificationEntity notification);

  Future<Either<Failure, Unit>> markAsRead(String id);

  Future<Either<Failure, Unit>> deleteNotification(String id);

  Future<Either<Failure, Unit>> clearAll();

  Future<Either<Failure, Unit>> markAllAsRead();
}