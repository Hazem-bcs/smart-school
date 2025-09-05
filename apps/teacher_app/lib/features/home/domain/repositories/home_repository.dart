import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';
import '../entities/class_entity.dart';
import '../entities/assignment_entity.dart';
import '../entities/notification_entity.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<ClassEntity>>> getClasses();
  Future<Either<Failure, List<AssignmentEntity>>> getAssignments();
  Future<Either<Failure, List<NotificationEntity>>> getNotifications();
  Future<Either<Failure, Unit>> markNotificationAsRead(String notificationId);
}