import 'package:core/domain/entities/subject_entity.dart';
import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';

import '../Subject_repository.dart';

class GetSubjectLListUseCase {
  final SubjectRepository repository;

  GetSubjectLListUseCase(this.repository);

  Future<Either<Failure, List<SubjectEntity>>> call() async {
    return await repository.getSubjectList();
  }
}