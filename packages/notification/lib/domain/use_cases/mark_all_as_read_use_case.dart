import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';

import '../notification_repositoty.dart';

class MarkAllAsReadUseCase {
  final NotificationRepository repository;

  MarkAllAsReadUseCase(this.repository);

  Future<Either<Failure, Unit>> call() async {
    return await repository.markAllAsRead();
  }
}


