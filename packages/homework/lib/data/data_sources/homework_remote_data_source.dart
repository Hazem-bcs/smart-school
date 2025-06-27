import 'package:core/network/dio_client.dart';
import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';

import '../models/homework_model.dart';
import '../models/question_model.dart';

// Abstract class defining the contract for the remote data source
abstract class HomeworkRemoteDataSource {
  Future<Either<Failure, List<HomeworkModel>>> getHomeworks(int studentId);
  Future<void> updateHomeworkStatus(
    int homeworkId,
    int mark,
  );
  Future<Either<Failure, List<QuestionModel>>> getQuestionList(int homeWorkId);
}

// Implementation that fetches data from an API
class HomeworkRemoteDataSourceImpl implements HomeworkRemoteDataSource {
  final DioClient dioClient;
  HomeworkRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<Either<Failure, List<HomeworkModel>>> getHomeworks(int studentId,
  ) async {
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
        "id": "1",
        "title": "حل مسائل الفصل الخامس",
        "subject": "رياضيات",
        "assignedDate": DateTime.now().toIso8601String(),
        "dueDate":
            DateTime.now().add(const Duration(days: 3)).toIso8601String(),
        "status": "pending",
      },
      {
        "id": "2",
        "title": "كتابة مقال عن رحلة",
        "subject": "لغة عربية",
        "assignedDate":
            DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
        "dueDate":
            DateTime.now().add(const Duration(days: 1)).toIso8601String(),
        "status": "pending",
      },
      {
        "id": "3",
        "title": "مراجعة الدرس الأول",
        "subject": "علوم",
        "assignedDate":
            DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
        "dueDate":
            DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
        "status": "completed",
      },
    ];
    return Right(dummyJson.map((json) => HomeworkModel.fromMap(json)).toList());
  }

  @override
  Future<void> updateHomeworkStatus(
    int homeworkId,
    int mark,
  ) async {
    // // Simulate an API call to update the status
    // print("Updating status for $homeworkId to $mark via API...");
    // await Future.delayed(const Duration(seconds: 1));
    // // In a real app, the API would return the updated object
    // return HomeworkModel(
    //   id: homeworkId.toString(),
    //   title: "Updated Title",
    //   subject: "رياضيات",
    //   assignedDate: DateTime.now(),
    //   dueDate: DateTime.now(),
    //   status: HomeworkStatus.values.firstWhere((e) => e.name == mark),
    // );
  }

  @override
  Future<Either<Failure, List<QuestionModel>>> getQuestionList(
    int homeWorkId,
  ) async {
    return Right([
      QuestionModel(
        questionNumber: 1,
        question: 'What is the programming language of Flutter?',
        options: ['dart', '++c', 'java script'],
        marks: 3,
        correctAnswer: 'dart',
      ),
      QuestionModel(
        questionNumber: 2,
        question: 'Flutter is developed by Google.',
        options: ['dart', '++c', 'java script'],
        correctAnswer: 'dart',
        marks: 9,
      ),
      QuestionModel(
        questionNumber: 3,
        question: 'What is the programming language of Flutter?',
        options: ['dart', '++c', 'java script'],
        marks: 3,
        correctAnswer: 'dart',
      ),
      QuestionModel(
        questionNumber: 4,
        question: 'Flutter is developed by Google.',
        correctAnswer: 'java script',
        options: ['dart', '++c', 'java script'],
        marks: 9,
      ),
    ]);
  }
}
