import 'package:core/domain/entities/subject_entity.dart';
import 'package:core/network/failures.dart';
import 'package:core/network/network_info.dart';
import 'package:dartz/dartz.dart';

import '../domain/Subject_repository.dart';
import 'data_sources/subject_local_data_source.dart';
import 'data_sources/subject_remote_data_source.dart';

class SubjectRepositoryImpl extends SubjectRepository {

  final SubjectRemoteDataSource remoteDataSource;
  final SubjectLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  SubjectRepositoryImpl({required this.remoteDataSource,required this.networkInfo,required this.localDataSource});

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

  @override
  Future<Either<Failure, List<SubjectEntity>>> getSubjectList() async {
    final studentId = await localDataSource.getId();
    if(await networkInfo.isConnected) {
      final result = await remoteDataSource.getSubjectList(studentId ?? 0);
      return result.fold(
            (failure) => Left(failure),
            (subjectModelList) => Right(subjectModelList.map((e) => e.toEntity()).toList(),),
      );
    }
    else {
      return Left(ConnectionFailure(message: 'connection failure'));
    }
  }
}