import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';

import '../notification_repositoty.dart';

class MarkAsReadUseCase {
  final NotificationRepository repository;

  MarkAsReadUseCase(this.repository);

  Future<Either<Failure, Unit>> call(String id) async {
    return await repository.markAsRead(id);
  }
}


