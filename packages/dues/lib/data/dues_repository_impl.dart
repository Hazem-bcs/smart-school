import 'package:core/network/failures.dart';
import 'package:core/network/network_info.dart';
import 'package:dartz/dartz.dart';

import '../domain/dues_repository.dart';
import '../domain/entities/due_entity.dart';
import 'datasources/dues_local_data_source.dart';
import 'datasources/dues_remote_datasource.dart';

class DuesRepositoryImpl extends DuesRepository {
  final DuesLocalDataSource localDataSource;
  final DuesRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  DuesRepositoryImpl({
    required this.networkInfo,
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<DueEntity>>> getMyDues() async {
    try {
      print('📦 Repository: Starting getMyDues process...');

      // Check network connectivity
      if (!await networkInfo.isConnected) {
        print('❌ No network connection');
        return Left(ConnectionFailure(message: 'لا يوجد اتصال بالإنترنت'));
      }

      // Get student ID from local storage
      final studentId = await localDataSource.getId();
      print('🔑 Retrieved student ID: ${studentId ?? "No ID found"}');

      if (studentId == null) {
        print('❌ No student ID found in local storage');
        return Left(CacheFailure(message: 'لم يتم العثور على معرف الطالب'));
      }

      // Fetch dues from remote source
      final result = await remoteDataSource.getMyDues(studentId);
      
      return result.fold(
        (failure) {
          print('❌ Remote data source failed: ${failure.message}');
          return Left(failure);
        },
        (dueModelList) {
          print('✅ Successfully fetched ${dueModelList.length} dues');
          final dueEntities = dueModelList.map((dueModel) => dueModel.toEntity()).toList();
          return Right(dueEntities);
        },
      );
    } catch (e) {
      print('❌ Unexpected error in getMyDues: $e');
      return Left(UnknownFailure(message: 'حدث خطأ غير متوقع: ${e.toString()}'));
    }
  }
}