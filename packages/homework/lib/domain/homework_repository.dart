import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';

import 'entites/homework_entity.dart';
import 'entites/question_entity.dart';


abstract class HomeworkRepository {
  Future<Either<Failure, List<HomeworkEntity>>> getHomeworks();

  Future<Either<Failure,List<QuestionEntity>>> getListQuestionEntities(int homeWorkId);

  Future<void> updateHomeworkStatus(int homeworkId, int mark);
}