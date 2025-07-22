import 'package:equatable/equatable.dart';

// Base class for all Zoom Meetings events
abstract class ZoomMeetingsEvent extends Equatable {
  const ZoomMeetingsEvent();

  @override
  List<Object> get props => [];
}

// Event to fetch all Zoom meetings
class GetZoomMeetings extends ZoomMeetingsEvent {
  const GetZoomMeetings();

  @override
  List<Object> get props => [];
}