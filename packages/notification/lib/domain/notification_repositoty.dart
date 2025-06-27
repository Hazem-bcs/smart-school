import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';

import 'entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<Either<Failure,List<NotificationEntity>>> getNotificationList();
}