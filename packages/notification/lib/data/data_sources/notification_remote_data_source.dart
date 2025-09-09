import 'package:core/network/dio_client.dart';
import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';

import '../models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<Either<Failure, List<NotificationModel>>> getNotificationList(
    int studentId,
  );
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final DioClient dioClient;

  NotificationRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<Either<Failure, List<NotificationModel>>> getNotificationList(
    int studentId,
  ) async {
    // Remote is disabled: backend won't store notifications. Always return empty.
    return const Right([]);
  }
}
