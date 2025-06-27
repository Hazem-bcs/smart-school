import 'package:core/network/failures.dart';
import 'package:core/network/network_info.dart';
import 'package:dartz/dartz.dart';


import '../domain/entities/notification_entity.dart';
import '../domain/notification_repositoty.dart';
import 'data_sources/notification_local_data_source.dart';
import 'data_sources/notification_remote_data_source.dart';

class NotificationRepositoryImpl extends NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;
  final NotificationLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NotificationRepositoryImpl({required this.networkInfo,required this.localDataSource,required this.remoteDataSource});

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotificationList() async {
    if(await networkInfo.isConnected) {
      final studentId = await localDataSource.getId();
      final result = await remoteDataSource.getNotificationList(studentId ?? 0);
      return result.fold(
        (failure) => Left(failure),
        (notificationList) => Right(notificationList.map((e) => e.toEntity(),).toList()),
      );
  }else {
      return Left(ConnectionFailure(message: 'connection failure'));
  }
  }

}