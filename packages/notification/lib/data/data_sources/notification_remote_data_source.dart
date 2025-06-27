import 'package:core/network/dio_client.dart';
import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';


import '../models/notification_model.dart';


abstract class NotificationRemoteDataSource {
  Future<Either<Failure, List<NotificationModel>>> getNotificationList(int studentId);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final DioClient dioClient;

  NotificationRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<Either<Failure, List<NotificationModel>>> getNotificationList(
      int studentId,) async {
    // try {
    //   final response = await dioClient.post(
    //     Constants.getHomeWorkListEndpoint,
    //     data: {'token': token},
    //   );
    //   final List<dynamic> res = response.data;
    //   final List<HomeworkModel> homeWorkModelList = [];
    //   for(int i =0; i<res.length; i++) {
    //     final ele = HomeworkModel.fromJson(res[i]);
    //     homeWorkModelList.add(ele);
    //   }
    //   return Right(homeWorkModelList);
    // } on DioException catch (e) {
    //   return Left(handleDioException(e));
    // } catch (e) {
    //   return Left(UnknownFailure(message: 'Unknown error occurred'));
    // }
    return Right([
      NotificationModel(
          id: "notif_001",
          title: "New Math Assignment",
          body: "Chapter 5 exercises due tomorrow by 11:59 PM",
          sentTime: DateTime(2023, 5, 15, 14, 30),
          isRead: false,
          imageUrl: "https://eduapp.com/math_icon.png",
          deepLink: "app://assignments/math_005"
      ),
      NotificationModel(
          id: "notif_002",
          title: "Grade Updated",
          body: "Your Science project grade is now available - 94% A",
          sentTime: DateTime(2023, 5, 16, 9, 15),
          isRead: true,
          deepLink: "app://grades/science_proj"
      ),
      NotificationModel(
          id: "notif_003",
          title: "System Maintenance",
          body: "The app will be down for maintenance tonight from 1-3 AM",
          sentTime: DateTime(2023, 5, 14, 18, 0),
          isRead: false
      ),
      NotificationModel(
          id: "notif_004",
          title: "Class Cancelled",
          body: "History class on Friday is cancelled - Prof. Smith is ill",
          sentTime: DateTime(2023, 5, 17, 10, 5),
          isRead: false,
          imageUrl: "https://eduapp.com/history_icon.png"
      ),
      NotificationModel(
          id: "notif_005",
          title: "Deadline Approaching",
          body: "Reminder: English essay due in 2 days",
          sentTime: DateTime(2023, 5, 18, 8, 0),
          isRead: false,
          deepLink: "app://assignments/eng_essay"
      )
    ]);
  }
}