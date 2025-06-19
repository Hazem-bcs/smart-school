import 'package:dartz/dartz.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../core/network/failures.dart';
import '../models/homework_model.dart';

// Abstract class defining the contract for the remote data source
abstract class HomeworkRemoteDataSource {
  Future<Either<Failure,List<HomeworkModel>>> getHomeworks(String token);
  Future<HomeworkModel> updateHomeworkStatus({required String homeworkId, required String newStatus});
}

// Implementation that fetches data from an API
class HomeworkRemoteDataSourceImpl implements HomeworkRemoteDataSource {
  final DioClient dioClient;
  HomeworkRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<Either<Failure,List<HomeworkModel>>> getHomeworks(String token) async {

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
    
    // For now, dummy data
    print("Fetching data from API...");
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    final List<Map<String, dynamic>> dummyJson = [
      {
        "id": "1", "title": "حل مسائل الفصل الخامس", "subject": "رياضيات",
        "assignedDate": DateTime.now().toIso8601String(),
        "dueDate": DateTime.now().add(const Duration(days: 3)).toIso8601String(),
        "status": "pending"
      },
      {
        "id": "2", "title": "كتابة مقال عن رحلة", "subject": "لغة عربية",
        "assignedDate": DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
        "dueDate": DateTime.now().add(const Duration(days: 1)).toIso8601String(),
        "status": "pending"
      },
      {
        "id": "3", "title": "مراجعة الدرس الأول", "subject": "علوم",
        "assignedDate": DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
        "dueDate": DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
        "status": "completed"
      }
    ];
    return Right(dummyJson.map((json) => HomeworkModel.fromMap(json)).toList());
  }

  @override
  Future<HomeworkModel> updateHomeworkStatus({required String homeworkId, required String newStatus}) async {
    // Simulate an API call to update the status
    print("Updating status for $homeworkId to $newStatus via API...");
    await Future.delayed(const Duration(seconds: 1));
    // In a real app, the API would return the updated object
    return HomeworkModel(id: homeworkId, title: "Updated Title", subject: "رياضيات", assignedDate: DateTime.now(), dueDate: DateTime.now(), status: HomeworkStatus.values.firstWhere((e) => e.name == newStatus));
  }
}