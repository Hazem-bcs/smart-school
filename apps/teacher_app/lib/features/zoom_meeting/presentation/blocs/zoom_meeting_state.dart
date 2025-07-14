import 'package:equatable/equatable.dart';
import '../../domain/entities/meeting_option_entity.dart';

abstract class ZoomMeetingState extends Equatable {
  const ZoomMeetingState();

  @override
  List<Object?> get props => [];
}

class ZoomMeetingInitial extends ZoomMeetingState {}

class ZoomMeetingLoading extends ZoomMeetingState {}

class ZoomMeetingDataLoaded extends ZoomMeetingState {
  final String topic;
  final List<String> availableClasses;
  final List<String> selectedClasses;
  final DateTime selectedDate;
  final DateTime selectedTime;
  final List<MeetingOptionEntity> meetingOptions;
  final Map<String, bool> optionStates;

  const ZoomMeetingDataLoaded({
    this.topic = '',
    required this.availableClasses,
    this.selectedClasses = const [],
    required this.selectedDate,
    required this.selectedTime,
    required this.meetingOptions,
    required this.optionStates,
  });

  ZoomMeetingDataLoaded copyWith({
    String? topic,
    List<String>? availableClasses,
    List<String>? selectedClasses,
    DateTime? selectedDate,
    DateTime? selectedTime,
    List<MeetingOptionEntity>? meetingOptions,
    Map<String, bool>? optionStates,
  }) {
    return ZoomMeetingDataLoaded(
      topic: topic ?? this.topic,
      availableClasses: availableClasses ?? this.availableClasses,
      selectedClasses: selectedClasses ?? this.selectedClasses,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      meetingOptions: meetingOptions ?? this.meetingOptions,
      optionStates: optionStates ?? this.optionStates,
    );
  }

  @override
  List<Object?> get props => [
    topic,
    availableClasses,
    selectedClasses,
    selectedDate,
    selectedTime,
    meetingOptions,
    optionStates,
  ];
}

class ZoomMeetingScheduling extends ZoomMeetingState {}

class ZoomMeetingScheduled extends ZoomMeetingState {
  final String meetingId;
  final String meetingUrl;
  final String password;

  const ZoomMeetingScheduled({
    required this.meetingId,
    required this.meetingUrl,
    required this.password,
  });

  @override
  List<Object?> get props => [meetingId, meetingUrl, password];
}

class ZoomMeetingError extends ZoomMeetingState {
  final String message;

  const ZoomMeetingError(this.message);

  @override
  List<Object?> get props => [message];
} 