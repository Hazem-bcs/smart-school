import 'package:core/network/failures.dart';
import 'package:core/network/network_info.dart';
import 'package:dartz/dartz.dart';

import '../domain/entities/resource_entity.dart';
import '../domain/resource_repositroty.dart';
import 'data_sources/resoruce_local_data_source.dart';
import 'data_sources/resoruce_remote_data_source.dart';

class ResourceRepositoryImpl extends ResourceRepository {
  final ResourceRemoteDataSource remoteDataSource;
  final ResourceLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ResourceRepositoryImpl({required this.remoteDataSource, required this.localDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, List<ResourceEntity>>> getResourceList() async {
    if(await networkInfo.isConnected) {
      final studentId = await localDataSource.getId();
      final result = await remoteDataSource.getResourceList(studentId ?? 0);
      return result.fold(
            (failure) => Left(failure),
            (resourceModelList) => Right(resourceModelList.map((e) => e.toEntity(),).toList()),
      );
    }
    else {
      return Left(ConnectionFailure(message: 'connect Failed'));
    }
  }
}