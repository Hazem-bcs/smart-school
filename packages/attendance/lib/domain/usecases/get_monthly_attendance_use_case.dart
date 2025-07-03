import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';
import '../attendance_repository.dart';
import '../entities/attendance_entity.dart';

class GetMonthlyAttendanceUseCase {
  final AttendanceRepository repository;

  GetMonthlyAttendanceUseCase(this.repository);

  Future<Either<Failure, List<MonthlyAttendanceEntity>>> call(int year) {
    return repository.getMonthlyAttendance(year);
  }
} 