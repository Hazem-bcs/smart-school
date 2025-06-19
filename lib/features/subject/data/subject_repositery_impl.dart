import 'package:dartz/dartz.dart';
import 'package:smart_school/core/network/failures.dart';
import 'package:smart_school/features/subject/data/data_sources/subject_remote_data_source.dart';
import 'package:smart_school/features/subject/domain/Subject_repository.dart';
import 'package:smart_school/features/subject/domain/subject_entity.dart';

class SubjectRepositoryImpl extends SubjectRepository {

  final SubjectRemoteDataSource remoteDataSource;

  SubjectRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, SubjectEntity>> getSubject(int id) async {
    final result = await remoteDataSource.getSubject(id);
    return result.fold(
      (failure) => Left(failure),
      (subjectModel) => Right(subjectModel.toEntity()),
    );
  }
}