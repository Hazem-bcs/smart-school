import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/zoom_meeting_entity.dart';
import '../../domain/usecases/schedule_meeting_usecase.dart';
import '../../domain/usecases/get_available_classes_usecase.dart';
import '../../domain/usecases/get_meeting_options_usecase.dart';
import 'zoom_meeting_event.dart';
import 'zoom_meeting_state.dart';

class ZoomMeetingBloc extends Bloc<ZoomMeetingEvent, ZoomMeetingState> {
  final ScheduleMeetingUseCase scheduleMeetingUseCase;
  final GetAvailableClassesUseCase getAvailableClassesUseCase;
  final GetMeetingOptionsUseCase getMeetingOptionsUseCase;

  ZoomMeetingBloc({
    required this.scheduleMeetingUseCase,
    required this.getAvailableClassesUseCase,
    required this.getMeetingOptionsUseCase,
  }) : super(ZoomMeetingInitial()) {
    on<LoadInitialData>(_onLoadInitialData);
    on<TopicChanged>(_onTopicChanged);
    on<ClassSelectionChanged>(_onClassSelectionChanged);
    on<DateChanged>(_onDateChanged);
    on<TimeChanged>(_onTimeChanged);
    on<MeetingOptionChanged>(_onMeetingOptionChanged);
    on<ScheduleMeeting>(_onScheduleMeeting);
  }

  Future<void> _onLoadInitialData(
    LoadInitialData event,
    Emitter<ZoomMeetingState> emit,
  ) async {
    emit(ZoomMeetingLoading());
    
    try {
      final classes = await getAvailableClassesUseCase();
      final options = await getMeetingOptionsUseCase();
      
      final optionStates = <String, bool>{};
      for (final option in options) {
        optionStates[option.id] = option.isEnabled;
      }
      
      emit(ZoomMeetingDataLoaded(
        availableClasses: classes,
        selectedDate: DateTime.now(),
        selectedTime: DateTime.now(),
        meetingOptions: options,
        optionStates: optionStates,
      ));
    } catch (e) {
      emit(ZoomMeetingError('Failed to load initial data: $e'));
    }
  }

  void _onTopicChanged(
    TopicChanged event,
    Emitter<ZoomMeetingState> emit,
  ) {
    if (state is ZoomMeetingDataLoaded) {
      final currentState = state as ZoomMeetingDataLoaded;
      emit(currentState.copyWith(topic: event.topic));
    }
  }

  void _onClassSelectionChanged(
    ClassSelectionChanged event,
    Emitter<ZoomMeetingState> emit,
  ) {
    if (state is ZoomMeetingDataLoaded) {
      final currentState = state as ZoomMeetingDataLoaded;
      final selectedClasses = List<String>.from(currentState.selectedClasses);
      
      if (event.isSelected) {
        if (!selectedClasses.contains(event.className)) {
          selectedClasses.add(event.className);
        }
      } else {
        selectedClasses.remove(event.className);
      }
      
      emit(currentState.copyWith(selectedClasses: selectedClasses));
    }
  }

  void _onDateChanged(
    DateChanged event,
    Emitter<ZoomMeetingState> emit,
  ) {
    if (state is ZoomMeetingDataLoaded) {
      final currentState = state as ZoomMeetingDataLoaded;
      emit(currentState.copyWith(selectedDate: event.date));
    }
  }

  void _onTimeChanged(
    TimeChanged event,
    Emitter<ZoomMeetingState> emit,
  ) {
    if (state is ZoomMeetingDataLoaded) {
      final currentState = state as ZoomMeetingDataLoaded;
      emit(currentState.copyWith(selectedTime: event.time));
    }
  }

  void _onMeetingOptionChanged(
    MeetingOptionChanged event,
    Emitter<ZoomMeetingState> emit,
  ) {
    if (state is ZoomMeetingDataLoaded) {
      final currentState = state as ZoomMeetingDataLoaded;
      final optionStates = Map<String, bool>.from(currentState.optionStates);
      optionStates[event.optionId] = event.isEnabled;
      
      emit(currentState.copyWith(optionStates: optionStates));
    }
  }

  Future<void> _onScheduleMeeting(
    ScheduleMeeting event,
    Emitter<ZoomMeetingState> emit,
  ) async {
    if (state is ZoomMeetingDataLoaded) {
      final currentState = state as ZoomMeetingDataLoaded;
      
      // Validate form
      if (currentState.topic.trim().isEmpty) {
        emit(ZoomMeetingError('Please enter a meeting topic'));
        return;
      }
      
      if (currentState.selectedClasses.isEmpty) {
        emit(ZoomMeetingError('Please select at least one class'));
        return;
      }
      
      emit(ZoomMeetingScheduling());
      
      try {
        final meeting = ZoomMeetingEntity(
          id: '',
          topic: currentState.topic,
          invitedClasses: currentState.selectedClasses,
          scheduledDate: currentState.selectedDate,
          scheduledTime: currentState.selectedTime,
          enableWaitingRoom: currentState.optionStates['waiting_room'] ?? true,
          recordAutomatically: currentState.optionStates['record_meeting'] ?? false,
        );
        
        final result = await scheduleMeetingUseCase(meeting);
        
        emit(ZoomMeetingScheduled(
          meetingId: result.meetingId ?? '',
          meetingUrl: result.meetingUrl ?? 'https://zoom.us/j/123456789',
          password: result.password ?? '',
        ));
      } catch (e) {
        emit(ZoomMeetingError('Failed to schedule meeting: $e'));
      }
    }
  }
} 