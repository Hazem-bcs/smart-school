import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';
import 'package:core/network/network_info.dart';
import '../domain/attendance_repository.dart';
import '../domain/entities/attendance_entity.dart';
import 'data_sources/attendance_remote_data_source.dart';
import 'data_sources/attendance_local_data_source.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceRemoteDataSource remoteDataSource;
  final AttendanceLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  const AttendanceRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<MonthlyAttendanceEntity>>> getMonthlyAttendance(int year) async {
    if (await networkInfo.isConnected) {
      final studentId = await localDataSource.getId() ?? 0;
      final result = await remoteDataSource.getMonthlyAttendance(studentId, year);
      return result.fold(
        (failure) => Left(failure),
        (list) => Right(list.map((model) => model.toEntity()).toList()),
      );
    } else {
      return Left(ConnectionFailure(message: 'Connection Error'));
    }
  }

  @override
  Future<Either<Failure, AttendanceEntity>> getAttendanceDetails(int year, int month) async {
    if (await networkInfo.isConnected) {
      final studentId = await localDataSource.getId() ?? 0;
      final result = await remoteDataSource.getAttendanceDetails(studentId, year, month);
      return result.fold(
        (failure) => Left(failure),
        (model) => Right(model.toEntity()),
      );
    } else {
      return Left(ConnectionFailure(message: 'Connection Error'));
    }
  }
} 