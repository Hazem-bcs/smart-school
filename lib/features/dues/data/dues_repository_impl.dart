import 'package:dartz/dartz.dart';
import 'package:smart_school/core/network/network_info.dart';
import 'package:smart_school/features/dues/domain/dues_repository.dart';
import 'package:smart_school/features/dues/data/datasources/dues_remote_datasource.dart';

import '../../../core/network/failures.dart';
import '../domain/entities/due_entity.dart';
import 'datasources/dues_local_data_source.dart';

class DuesRepositoryImpl extends DuesRepository {
  final DuesLocalDataSource localDataSource;
  final DuesRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;


  DuesRepositoryImpl({required this.networkInfo,required this.localDataSource,required this.remoteDataSource});

  @override
  Future<Either<Failure, List<DueEntity>>> getMyDues() async {
    if(await networkInfo.isConnected) {
      final studentId = await localDataSource.getId();
      final result = await remoteDataSource.getMyDues(studentId ?? 0);
      return result.fold(
        (failure) => Left(failure),
        (dueModelList) => Right(dueModelList.map((dueModel) => dueModel.toEntity()).toList(),),
      );
    }
    else {
      return Left(ConnectionFailure(message: 'connection fail'));
    }
  }
}