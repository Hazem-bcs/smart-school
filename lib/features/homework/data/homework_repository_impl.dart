import 'package:dartz/dartz.dart';
import 'package:smart_school/features/homework/data/data_sources/home_work_local_data_source.dart';

import '../../../core/network/failures.dart';
import '../../../core/network/network_info.dart';
import '../domain/entites/homework_entity.dart';
import '../domain/homework_repository.dart';
import 'data_sources/homework_remote_data_source.dart';


class HomeworkRepositoryImpl implements HomeworkRepository {
  final HomeworkRemoteDataSource remoteDataSource;
  final HomeWorkLocalDataSource homeWorkLocalDataSource;
  final NetworkInfo networkInfo;

  HomeworkRepositoryImpl({required this.remoteDataSource,required this.homeWorkLocalDataSource,required this.networkInfo});

  @override
  Future<Either<Failure, List<HomeworkEntity>>> getHomeworks() async {
    if (await networkInfo.isConnected) {
      final token = await homeWorkLocalDataSource.getToken();
      final result = await remoteDataSource.getHomeworks(token ?? "");
      return result.fold(
              (failure) => left(failure),
              (homeWorkList) async {
                return Right(homeWorkList.map((ele) => ele.toEntity()).toList());
          }
      );
    } else {
      return Left(ConnectionFailure(message: 'Connection Error'));
    }
  }

  // @override
  // Future<Either<Failure, HomeworkEntity>> updateHomeworkStatus({required String homeworkId, required String newStatus}) async {
  //
  // }
}