import 'package:core/network/failures.dart';
import 'package:core/network/network_info.dart';
import 'package:dartz/dartz.dart';


import '../domain/entities/notification_entity.dart';
import '../domain/notification_repositoty.dart';
import 'data_sources/notification_local_data_source.dart';
import 'data_sources/notification_remote_data_source.dart';
import 'models/notification_model.dart';

class NotificationRepositoryImpl extends NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;
  final NotificationLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NotificationRepositoryImpl({required this.networkInfo,required this.localDataSource,required this.remoteDataSource});

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotificationList() async {
    var localEither = await localDataSource.getNotificationList();
    return localEither.fold(
      (failure) => Left(failure),
      (list) => Right(list.map((e) => e.toEntity()).toList()),
    );
  }

  @override
  Future<Either<Failure, Unit>> addNotification(NotificationEntity notification) async {
    final model = NotificationModel.fromEntity(notification);
    return localDataSource.addNotification(model);
  }

  @override
  Future<Either<Failure, Unit>> markAsRead(String id) async {
    return localDataSource.markAsRead(id);
  }

  @override
  Future<Either<Failure, Unit>> deleteNotification(String id) async {
    return localDataSource.deleteNotification(id);
  }

  @override
  Future<Either<Failure, Unit>> clearAll() async {
    return localDataSource.clearAll();
  }

  @override
  Future<Either<Failure, Unit>> markAllAsRead() async {
    return localDataSource.markAllAsRead();
  }
}