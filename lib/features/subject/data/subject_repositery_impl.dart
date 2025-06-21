import 'package:dartz/dartz.dart';
import 'package:smart_school/core/network/failures.dart';
import 'package:smart_school/core/network/network_info.dart';
import 'package:smart_school/features/subject/data/data_sources/subject_remote_data_source.dart';
import 'package:smart_school/features/subject/domain/Subject_repository.dart';
import 'package:smart_school/features/subject/domain/subject_entity.dart';

class SubjectRepositoryImpl extends SubjectRepository {

  final SubjectRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  SubjectRepositoryImpl({required this.remoteDataSource,required this.networkInfo});

  @override
  Future<Either<Failure, SubjectEntity>> getSubject(int id) async {
    if(await networkInfo.isConnected) {
      final result = await remoteDataSource.getSubject(id);
      return result.fold(
            (failure) => Left(failure),
            (subjectModel) => Right(subjectModel.toEntity()),
      );
    }
    else {
      return Left(ConnectionFailure(message: 'connection failure'));
    }
  }
}