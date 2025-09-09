import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';

import '../notification_repositoty.dart';

class ClearNotificationsUseCase {
  final NotificationRepository repository;

  ClearNotificationsUseCase(this.repository);

  Future<Either<Failure, Unit>> call() async {
    return await repository.clearAll();
  }
}


