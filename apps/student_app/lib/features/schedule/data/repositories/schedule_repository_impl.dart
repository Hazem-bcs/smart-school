import '../../domain/repositories/schedule_repository.dart';
import '../../domain/entities/schedule_entity.dart';
import '../data_sources/schedule_remote_data_source.dart';
import '../models/schedule_model.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleRemoteDataSource remoteDataSource;

  ScheduleRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ScheduleEntity>> getScheduleForDate(DateTime date) async {
    try {
      final scheduleModels = await remoteDataSource.getScheduleForDate(date);
      return scheduleModels.map((model) => model as ScheduleEntity).toList();
    } catch (e) {
      throw Exception('Failed to get schedule for date: $e');
    }
  }

  @override
  Future<List<ScheduleEntity>> getScheduleForWeek(DateTime weekStart) async {
    try {
      final scheduleModels = await remoteDataSource.getScheduleForWeek(weekStart);
      return scheduleModels.map((model) => model as ScheduleEntity).toList();
    } catch (e) {
      throw Exception('Failed to get schedule for week: $e');
    }
  }

  @override
  Future<List<ScheduleEntity>> getScheduleForMonth(DateTime month) async {
    try {
      final scheduleModels = await remoteDataSource.getScheduleForMonth(month);
      return scheduleModels.map((model) => model as ScheduleEntity).toList();
    } catch (e) {
      throw Exception('Failed to get schedule for month: $e');
    }
  }

  @override
  Future<ScheduleEntity> createSchedule(ScheduleEntity schedule) async {
    try {
      final scheduleModel = ScheduleModel(
        id: schedule.id,
        title: schedule.title,
        description: schedule.description,
        startTime: schedule.startTime,
        endTime: schedule.endTime,
        className: schedule.className,
        subject: schedule.subject,
        teacherId: schedule.teacherId,
        location: schedule.location,
        type: schedule.type,
        status: schedule.status,
      );
      
      final createdModel = await remoteDataSource.createSchedule(scheduleModel);
      return createdModel as ScheduleEntity;
    } catch (e) {
      throw Exception('Failed to create schedule: $e');
    }
  }

  @override
  Future<ScheduleEntity> updateSchedule(ScheduleEntity schedule) async {
    try {
      final scheduleModel = ScheduleModel(
        id: schedule.id,
        title: schedule.title,
        description: schedule.description,
        startTime: schedule.startTime,
        endTime: schedule.endTime,
        className: schedule.className,
        subject: schedule.subject,
        teacherId: schedule.teacherId,
        location: schedule.location,
        type: schedule.type,
        status: schedule.status,
      );
      
      final updatedModel = await remoteDataSource.updateSchedule(scheduleModel);
      return updatedModel as ScheduleEntity;
    } catch (e) {
      throw Exception('Failed to update schedule: $e');
    }
  }

  @override
  Future<void> deleteSchedule(String scheduleId) async {
    try {
      await remoteDataSource.deleteSchedule(scheduleId);
    } catch (e) {
      throw Exception('Failed to delete schedule: $e');
    }
  }
} 