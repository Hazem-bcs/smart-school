import 'package:core/domain/entities/subject_entity.dart';
import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';

import '../Subject_repository.dart';

class GetSubjectUseCase {
  final SubjectRepository repository;

  GetSubjectUseCase(this.repository);

  Future<Either<Failure, SubjectEntity>> call(int id) async {
    return await repository.getSubject(id);
  }
}
