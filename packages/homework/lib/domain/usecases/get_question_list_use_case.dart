import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';

import '../entites/question_entity.dart';
import '../homework_repository.dart';

class GetQuestionListUseCase {
  final HomeworkRepository repository;

  GetQuestionListUseCase(this.repository);

  Future<Either<Failure,List<QuestionEntity>>> call(int homeWorkId) async {
    return await repository.getListQuestionEntities(homeWorkId);
  }
}