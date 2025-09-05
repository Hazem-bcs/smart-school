import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import '../../domain/entities/zoom_meeting_entity.dart';
import '../../domain/usecases/get_scheduled_meetings_usecase.dart';
import '../../domain/usecases/get_join_link_usecase.dart';
import 'meetings_list_event.dart';
import 'meetings_list_state.dart';
import 'package:core/network/failures.dart';

class MeetingsListBloc extends Bloc<MeetingsListEvent, MeetingsListState> {
  final GetScheduledMeetingsUseCase getScheduledMeetingsUseCase;
  final GetJoinLinkUseCase getJoinLinkUseCase;

  MeetingsListBloc({required this.getScheduledMeetingsUseCase, required this.getJoinLinkUseCase}) : super(MeetingsListInitial()) {
    on<LoadMeetings>(_onLoadMeetings);
    on<RefreshMeetings>(_onRefreshMeetings);
    on<JoinMeetingRequested>(_onJoinMeetingRequested);
  }

  Future<void> _onLoadMeetings(
    LoadMeetings event,
    Emitter<MeetingsListState> emit,
  ) async {
    emit(MeetingsListLoading());
    final Either<Failure, List<ZoomMeetingEntity>> result = await getScheduledMeetingsUseCase();
    result.fold(
      (failure) => emit(MeetingsListError(failure.message)),
      (meetings) => emit(MeetingsListLoaded(meetings: meetings)),
    );
  }

  Future<void> _onRefreshMeetings(
    RefreshMeetings event,
    Emitter<MeetingsListState> emit,
  ) async {
    final Either<Failure, List<ZoomMeetingEntity>> result = await getScheduledMeetingsUseCase();
    result.fold(
      (failure) => emit(MeetingsListError(failure.message)),
      (meetings) => emit(MeetingsListLoaded(meetings: meetings)),
    );
  }

  Future<void> _onJoinMeetingRequested(
    JoinMeetingRequested event,
    Emitter<MeetingsListState> emit,
  ) async {
    final result = await getJoinLinkUseCase(event.meetingId);
    result.fold(
      (failure) => emit(MeetingsListError(failure.message)),
      (url) => emit(MeetingJoinLinkReady(url)),
    );
  }
}


