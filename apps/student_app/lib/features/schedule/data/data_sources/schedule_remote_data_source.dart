import '../models/schedule_model.dart';
import '../../domain/entities/schedule_entity.dart';

abstract class ScheduleRemoteDataSource {
  Future<List<ScheduleModel>> getScheduleForDate(DateTime date);
  Future<List<ScheduleModel>> getScheduleForWeek(DateTime weekStart);
  Future<List<ScheduleModel>> getScheduleForMonth(DateTime month);
  Future<ScheduleModel> createSchedule(ScheduleModel schedule);
  Future<ScheduleModel> updateSchedule(ScheduleModel schedule);
  Future<void> deleteSchedule(String scheduleId);
}

class ScheduleRemoteDataSourceImpl implements ScheduleRemoteDataSource {
  @override
  Future<List<ScheduleModel>> getScheduleForDate(DateTime date) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock data
    return [
      ScheduleModel(
        id: '1',
        title: 'Mathematics Class',
        description: 'Advanced algebra and calculus',
        startTime: DateTime(date.year, date.month, date.day, 9, 0),
        endTime: DateTime(date.year, date.month, date.day, 10, 30),
        className: 'Grade 10A',
        subject: 'Mathematics',
        teacherId: 'teacher1',
        location: 'Room 101',
        type: ScheduleType.classType,
        status: ScheduleStatus.upcoming,
      ),
      ScheduleModel(
        id: '2',
        title: 'Physics Lab',
        description: 'Practical experiments',
        startTime: DateTime(date.year, date.month, date.day, 11, 0),
        endTime: DateTime(date.year, date.month, date.day, 12, 30),
        className: 'Grade 11B',
        subject: 'Physics',
        teacherId: 'teacher1',
        location: 'Lab 2',
        type: ScheduleType.classType,
        status: ScheduleStatus.upcoming,
      ),
    ];
  }

  @override
  Future<List<ScheduleModel>> getScheduleForWeek(DateTime weekStart) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    List<ScheduleModel> weekSchedule = [];
    for (int i = 0; i < 7; i++) {
      final date = weekStart.add(Duration(days: i));
      weekSchedule.addAll(await getScheduleForDate(date));
    }
    
    return weekSchedule;
  }

  @override
  Future<List<ScheduleModel>> getScheduleForMonth(DateTime month) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    
    List<ScheduleModel> monthSchedule = [];
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(month.year, month.month, day);
      monthSchedule.addAll(await getScheduleForDate(date));
    }
    
    return monthSchedule;
  }

  @override
  Future<ScheduleModel> createSchedule(ScheduleModel schedule) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    // Return the created schedule with a new ID
    return ScheduleModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
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
  }

  @override
  Future<ScheduleModel> updateSchedule(ScheduleModel schedule) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    return schedule;
  }

  @override
  Future<void> deleteSchedule(String scheduleId) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
  }
} 