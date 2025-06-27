import 'package:core/domain/entities/subject_entity.dart';
import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';

abstract class SubjectRepository {
  Future<Either<Failure,SubjectEntity>> getSubject(int id);
  Future<Either<Failure,List<SubjectEntity>>> getSubjectList();
}