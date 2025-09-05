import 'package:equatable/equatable.dart';
import '../../domain/entities/zoom_meeting_entity.dart';

abstract class MeetingsListState extends Equatable {
  const MeetingsListState();

  @override
  List<Object?> get props => [];
}

class MeetingsListInitial extends MeetingsListState {}

class MeetingsListLoading extends MeetingsListState {}

class MeetingsListLoaded extends MeetingsListState {
  final List<ZoomMeetingEntity> meetings;
  const MeetingsListLoaded({required this.meetings});

  @override
  List<Object?> get props => [meetings];
}

class MeetingsListError extends MeetingsListState {
  final String message;
  const MeetingsListError(this.message);

  @override
  List<Object?> get props => [message];
}

class MeetingJoinLinkReady extends MeetingsListState {
  final String url;
  const MeetingJoinLinkReady(this.url);

  @override
  List<Object?> get props => [url];
}


