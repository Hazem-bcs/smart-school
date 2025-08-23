import '../entities/schedule_entity.dart';

abstract class ScheduleRepository {
  Future<List<ScheduleEntity>> getScheduleForDate(DateTime date);
} 