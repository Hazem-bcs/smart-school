import 'package:dartz/dartz.dart';
import 'package:smart_school/features/subject/domain/Subject_repository.dart';
import 'package:smart_school/features/subject/domain/subject_entity.dart';

import '../../../core/network/failures.dart';

class GetSubjectUseCase {
  final SubjectRepository repository;

  GetSubjectUseCase(this.repository);

  Future<Either<Failure, SubjectEntity>> call(int id) async {
    return await repository.getSubject(id);
  }
}
