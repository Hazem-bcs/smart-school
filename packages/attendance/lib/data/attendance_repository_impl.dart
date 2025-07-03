import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';
import 'package:core/network/network_info.dart';
import '../domain/attendance_repository.dart';
import '../domain/entities/attendance_entity.dart';
import 'data_sources/attendance_remote_data_source.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AttendanceRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<MonthlyAttendanceEntity>>> getMonthlyAttendance(int year) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getMonthlyAttendance(year);
        return Right(result.map((model) => model.toEntity()).toList());
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(ConnectionFailure(message: 'Connection Error'));
    }
  }

  @override
  Future<Either<Failure, AttendanceEntity>> getAttendanceDetails(int year, int month) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getAttendanceDetails(year, month);
        return Right(result.toEntity());
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(ConnectionFailure(message: 'Connection Error'));
    }
  }
} 