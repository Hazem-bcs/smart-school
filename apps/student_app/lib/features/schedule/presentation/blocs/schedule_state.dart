import 'package:equatable/equatable.dart';
import '../../domain/entities/schedule_entity.dart';

abstract class ScheduleState extends Equatable {
  const ScheduleState();

  @override
  List<Object?> get props => [];
}

class ScheduleInitial extends ScheduleState {}

class ScheduleLoading extends ScheduleState {}

class ScheduleLoaded extends ScheduleState {
  final List<ScheduleEntity> schedules;
  final DateTime selectedDate;

  const ScheduleLoaded({
    required this.schedules,
    required this.selectedDate,
  });

  @override
  List<Object?> get props => [schedules, selectedDate];
}

class ScheduleCreated extends ScheduleState {
  final ScheduleEntity schedule;

  const ScheduleCreated(this.schedule);

  @override
  List<Object?> get props => [schedule];
}

class ScheduleUpdated extends ScheduleState {
  final ScheduleEntity schedule;

  const ScheduleUpdated(this.schedule);

  @override
  List<Object?> get props => [schedule];
}

class ScheduleDeleted extends ScheduleState {
  final String scheduleId;

  const ScheduleDeleted(this.scheduleId);

  @override
  List<Object?> get props => [scheduleId];
}

class ScheduleError extends ScheduleState {
  final String message;

  const ScheduleError(this.message);

  @override
  List<Object?> get props => [message];
} 