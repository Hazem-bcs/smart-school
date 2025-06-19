import 'package:dartz/dartz.dart';
import 'package:smart_school/core/network/failures.dart';
import 'package:smart_school/features/subject/domain/subject_entity.dart';

abstract class SubjectRepository {
  Future<Either<Failure,SubjectEntity>> getSubject(int id);
}