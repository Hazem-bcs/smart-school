import 'package:equatable/equatable.dart';

import '../../domain/entities/zoom_meeting.dart'; // Ensure this path is correct

// Base class for all Zoom Meetings states
abstract class ZoomMeetingsState extends Equatable {
  const ZoomMeetingsState();

  @override
  List<Object> get props => [];
}

// Initial state when the BLoC is created
class ZoomMeetingsInitial extends ZoomMeetingsState {
  const ZoomMeetingsInitial();
}

// State when meetings are being loaded
class ZoomMeetingsLoading extends ZoomMeetingsState {
  const ZoomMeetingsLoading();
}

// State when meetings are loaded successfully
class ZoomMeetingsLoaded extends ZoomMeetingsState {
  final List<ZoomMeeting> meetings;

  const ZoomMeetingsLoaded({required this.meetings});

  @override
  List<Object> get props => [meetings];
}

// State when there's an error loading meetings
class ZoomMeetingsError extends ZoomMeetingsState {
  final String message;

  const ZoomMeetingsError({required this.message});

  @override
  List<Object> get props => [message];
}
