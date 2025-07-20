import 'package:equatable/equatable.dart';

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