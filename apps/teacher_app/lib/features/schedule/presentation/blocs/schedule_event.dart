import 'package:equatable/equatable.dart';
import '../../domain/entities/schedule_entity.dart';

abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();

  @override
  List<Object?> get props => [];
}

class LoadScheduleForDate extends ScheduleEvent {
  final DateTime date;

  const LoadScheduleForDate(this.date);

  @override
  List<Object?> get props => [date];
}

class LoadScheduleForWeek extends ScheduleEvent {
  final DateTime weekStart;

  const LoadScheduleForWeek(this.weekStart);

  @override
  List<Object?> get props => [weekStart];
}

class LoadScheduleForMonth extends ScheduleEvent {
  final DateTime month;

  const LoadScheduleForMonth(this.month);

  @override
  List<Object?> get props => [month];
}

class CreateSchedule extends ScheduleEvent {
  final ScheduleEntity schedule;

  const CreateSchedule(this.schedule);

  @override
  List<Object?> get props => [schedule];
}

class UpdateSchedule extends ScheduleEvent {
  final ScheduleEntity schedule;

  const UpdateSchedule(this.schedule);

  @override
  List<Object?> get props => [schedule];
}

class DeleteSchedule extends ScheduleEvent {
  final String scheduleId;

  const DeleteSchedule(this.scheduleId);

  @override
  List<Object?> get props => [scheduleId];
} 