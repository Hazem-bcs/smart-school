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

  ResourceRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ResourceEntity>>> getResourceList() async {
    print('PRINTDEBUG: [ResourceRepositoryImpl] getResourceList called');
    try {
      if (await networkInfo.isConnected) {
        print('PRINTDEBUG: [ResourceRepositoryImpl] Network is connected');
        final studentId = await localDataSource.getId();
        final result = await remoteDataSource.getResourceList(studentId ?? 0);
        return result.fold(
          (failure) {
            print('PRINTDEBUG: [ResourceRepositoryImpl] Failure from remoteDataSource: ${failure.message}');
            return Left(failure);
          },
          (resourceModelList) {
            print('PRINTDEBUG: [ResourceRepositoryImpl] Success, resourceModelList length: ${resourceModelList.length}');
            return Right(resourceModelList.map((e) => e.toEntity()).toList());
          },
        );
      } else {
        print('PRINTDEBUG: [ResourceRepositoryImpl] Network is NOT connected');
        return Left(ConnectionFailure(message: 'connect Failed'));
      }
    } catch (e, stackTrace) {
      print('PRINTDEBUG: [ResourceRepositoryImpl] Exception: $e');
      print('PRINTDEBUG: [ResourceRepositoryImpl] StackTrace: $stackTrace');
      return Left(ServerFailure(message: 'حدث خطأ غير متوقع أثناء تحميل الموارد.'));
    }
  }
}