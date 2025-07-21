import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';
import '../entities/schedule_entity.dart';

abstract class ScheduleRepository {
  Future<Either<Failure, List<ScheduleEntity>>> getScheduleForDate(DateTime date);
} 