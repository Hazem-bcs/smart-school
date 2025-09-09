import 'package:core/network/dio_client.dart';
import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:core/constant.dart';

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
    // ignore: avoid_print
    print('HomeworkRemoteDataSource.getHomeworks -> studentId=$studentId');
    try {
      final responseEither = await dioClient.post(
        Constants.getAllQuiz,
        data: {'id': studentId},
      );
      print('HomeworkRemotesddsfsdfsdfdsDataSource.getHomeworks -> responseEither=$responseEither');
      return responseEither.fold(
        (failure) => Left(failure),
        (response) {
          try {
            final List<dynamic> data = response.data['data'] as List<dynamic>;
            // ignore: avoid_print
            print('HomeworkRemoteDataSource.getHomeworks: fetched=${data.length}');
            final list = data.whereType<Map<String, dynamic>>().map((item) {
              final nameField = item['name'];
              final title = (nameField is Map<String, dynamic>)
                  ? (nameField['ar'] ?? nameField['en'] ?? 'اختبار')
                  : (nameField?.toString() ?? 'اختبار');
              final createdAt = DateTime.tryParse(item['created_at']?.toString() ?? '');
              final updatedAt = DateTime.tryParse(item['updated_at']?.toString() ?? '');
              return HomeworkModel(
                id: item['id'].toString(),
                title: title,
                subject: _mapSubjectIdToName(item['subject_id']),
                assignedDate: createdAt ?? DateTime.now(),
                dueDate: updatedAt ?? DateTime.now(),
                status: HomeworkStatus.pending,
              );
            }).toList();
            return Right(list);
          } catch (e) {
            return Left(UnknownFailure(message: 'تنسيق قائمة الاختبارات غير صالح'));
          }
        },
      );
    } catch (e) {
      return Left(UnknownFailure(message: 'خطأ غير معروف: ${e.toString()}'));
    }
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
    // ignore: avoid_print
    print('HomeworkRemoteDataSource.getQuestionList -> quizId=$homeWorkId');
    try {
      final responseEither = await dioClient.post(
        Constants.getOneQuiz,
        data: {'id': homeWorkId},
      );
      return responseEither.fold(
        (failure) => Left(failure),
        (response) {
          try {
            final List<dynamic> data = response.data['data'] as List<dynamic>;
            // ignore: avoid_print
            print('HomeworkRemoteDataSource.getQuestionList: fetched=${data.length}');
            final questions = data.whereType<Map<String, dynamic>>().map((q) {
              final answersRaw = (q['answers']?.toString() ?? '').trim();
              final options = answersRaw.isNotEmpty
                  ? answersRaw.split(' - ').map((e) => e.trim()).where((e) => e.isNotEmpty).toList()
                  : <String>[];
              return QuestionModel(
                questionNumber: q['id'] is int ? q['id'] as int : int.tryParse(q['id'].toString()) ?? 0,
                question: q['title']?.toString() ?? '',
                options: options,
                marks: q['score'] is int ? q['score'] as int : int.tryParse(q['score'].toString()) ?? 0,
                correctAnswer: q['right_answer']?.toString() ?? '',
              );
            }).toList();
            return Right(questions);
          } catch (e) {
            return Left(UnknownFailure(message: 'تنسيق أسئلة الاختبار غير صالح'));
          }
        },
      );
    } catch (e) {
      return Left(UnknownFailure(message: 'خطأ غير معروف: ${e.toString()}'));
    }
  }

  String _mapSubjectIdToName(dynamic subjectId) {
    final id = subjectId is int ? subjectId : int.tryParse(subjectId?.toString() ?? '') ?? 0;
    switch (id) {
      case 1:
        return 'لغة عربية';
      case 2:
        return 'علوم';
      case 3:
        return 'رياضيات';
      default:
        return 'اختبار';
    }
  }
}
