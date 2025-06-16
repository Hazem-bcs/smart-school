import 'package:dartz/dartz.dart';

import '../../../../core/network/failures.dart';
import '../entites/homework_entity.dart';
import '../homework_repository.dart';


class GetHomeworkUseCase {
  final HomeworkRepository repository;

  GetHomeworkUseCase(this.repository);

  Future<Either<Failure, List<HomeworkEntity>>> call() async {
    return await repository.getHomeworks();
  }
}