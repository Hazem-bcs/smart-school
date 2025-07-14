import 'package:equatable/equatable.dart';

abstract class ZoomMeetingEvent extends Equatable {
  const ZoomMeetingEvent();

  @override
  List<Object?> get props => [];
}

class LoadInitialData extends ZoomMeetingEvent {}

class TopicChanged extends ZoomMeetingEvent {
  final String topic;

  const TopicChanged(this.topic);

  @override
  List<Object?> get props => [topic];
}

class ClassSelectionChanged extends ZoomMeetingEvent {
  final String className;
  final bool isSelected;

  const ClassSelectionChanged(this.className, this.isSelected);

  @override
  List<Object?> get props => [className, isSelected];
}

class DateChanged extends ZoomMeetingEvent {
  final DateTime date;

  const DateChanged(this.date);

  @override
  List<Object?> get props => [date];
}

class TimeChanged extends ZoomMeetingEvent {
  final DateTime time;

  const TimeChanged(this.time);

  @override
  List<Object?> get props => [time];
}

class MeetingOptionChanged extends ZoomMeetingEvent {
  final String optionId;
  final bool isEnabled;

  const MeetingOptionChanged(this.optionId, this.isEnabled);

  @override
  List<Object?> get props => [optionId, isEnabled];
}

class ScheduleMeeting extends ZoomMeetingEvent {} 