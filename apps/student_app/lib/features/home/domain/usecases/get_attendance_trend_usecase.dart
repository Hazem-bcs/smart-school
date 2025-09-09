import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';
import '../repositories/home_repository.dart';
import '../entities/attendance_trend_entity.dart';

class GetAttendanceTrendUseCase {
  final HomeRepository repository;
  GetAttendanceTrendUseCase(this.repository);

  Future<Either<Failure, AttendanceTrendEntity>> call(DateTime startDate) async {
    return await repository.getAttendanceTrend(startDate);
  }
}
