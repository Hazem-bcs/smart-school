import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';
import 'entities/attendance_entity.dart';

abstract class AttendanceRepository {
  Future<Either<Failure, List<MonthlyAttendanceEntity>>> getMonthlyAttendance(int year);
  Future<Either<Failure, AttendanceEntity>> getAttendanceDetails(int year, int month);
} 