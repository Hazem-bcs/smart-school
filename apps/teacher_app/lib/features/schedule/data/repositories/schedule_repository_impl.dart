import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';
import '../../domain/repositories/schedule_repository.dart';
import '../../domain/entities/schedule_entity.dart';
import '../data_sources/schedule_remote_data_source.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleRemoteDataSource remoteDataSource;

  ScheduleRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<ScheduleEntity>>> getScheduleForDate(DateTime date) async {
    final result = await remoteDataSource.getScheduleForDate(date);
    return result.fold(
      (failure) => Left(failure),
      (models) => Right(models.map((model) => model.toEntity()).toList()),
    );
  }
} 