import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';
import '../attendance_repository.dart';
import '../entities/attendance_entity.dart';

class GetAttendanceDetailsUseCase {
  final AttendanceRepository repository;

  const GetAttendanceDetailsUseCase(this.repository);

  Future<Either<Failure, AttendanceEntity>> call(int year, int month) {
    return repository.getAttendanceDetails(year, month);
  }
} 