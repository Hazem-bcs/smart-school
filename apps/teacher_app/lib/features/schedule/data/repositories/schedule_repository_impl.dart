import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';
import 'package:teacher_app/core/local_data_source.dart';
import '../../domain/repositories/schedule_repository.dart';
import '../../domain/entities/schedule_entity.dart';
import '../data_sources/schedule_remote_data_source.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleRemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;

  ScheduleRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<Either<Failure, List<ScheduleEntity>>> getScheduleForDate(DateTime date) async {
    final teacherId = await localDataSource.getUserId() ?? 0;
    final result = await remoteDataSource.getScheduleForDate(date, teacherId);
    return result.fold(
      (failure) => Left(failure),
      (models) => Right(models.map((model) => model.toEntity()).toList()),
    );
  }
} 