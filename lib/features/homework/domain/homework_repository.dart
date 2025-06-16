import 'package:dartz/dartz.dart';

import '../../../core/network/failures.dart';
import 'entites/homework_entity.dart';


abstract class HomeworkRepository {
  Future<Either<Failure, List<HomeworkEntity>>> getHomeworks();

  // Future<Either<Failure, HomeworkEntity>> updateHomeworkStatus({
  //   required String homeworkId,
  //   required String newStatus,
  // });
}