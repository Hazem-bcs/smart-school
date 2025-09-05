import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';
import '../entities/notification_entity.dart';
import '../repositories/home_repository.dart';

class GetNotificationsUseCase {
  final HomeRepository repository;

  GetNotificationsUseCase(this.repository);

  Future<Either<Failure, List<NotificationEntity>>> call() async => repository.getNotifications();
} 