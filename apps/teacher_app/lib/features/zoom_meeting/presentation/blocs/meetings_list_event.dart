import 'package:equatable/equatable.dart';

abstract class MeetingsListEvent extends Equatable {
  const MeetingsListEvent();

  @override
  List<Object?> get props => [];
}

class LoadMeetings extends MeetingsListEvent {}

class RefreshMeetings extends MeetingsListEvent {}

class JoinMeetingRequested extends MeetingsListEvent {
  final String meetingId;
  const JoinMeetingRequested(this.meetingId);
  @override
  List<Object?> get props => [meetingId];
}


