import '../entities/schedule_entity.dart';

abstract class ScheduleRepository {
  Future<List<ScheduleEntity>> getScheduleForDate(DateTime date);
  Future<List<ScheduleEntity>> getScheduleForWeek(DateTime weekStart);
  Future<List<ScheduleEntity>> getScheduleForMonth(DateTime month);
  Future<ScheduleEntity> createSchedule(ScheduleEntity schedule);
  Future<ScheduleEntity> updateSchedule(ScheduleEntity schedule);
  Future<void> deleteSchedule(String scheduleId);
} 