import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_schedule_for_date_usecase.dart';
import '../../domain/usecases/get_schedule_for_week_usecase.dart';
import '../../domain/usecases/create_schedule_usecase.dart';
import 'schedule_event.dart';
import 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final GetScheduleForDateUseCase getScheduleForDateUseCase;
  final GetScheduleForWeekUseCase getScheduleForWeekUseCase;
  final CreateScheduleUseCase createScheduleUseCase;

  ScheduleBloc({
    required this.getScheduleForDateUseCase,
    required this.getScheduleForWeekUseCase,
    required this.createScheduleUseCase,
  }) : super(ScheduleInitial()) {
    on<LoadScheduleForDate>(_onLoadScheduleForDate);
    on<LoadScheduleForWeek>(_onLoadScheduleForWeek);
    on<CreateSchedule>(_onCreateSchedule);
    on<UpdateSchedule>(_onUpdateSchedule);
    on<DeleteSchedule>(_onDeleteSchedule);
  }

  void _onLoadScheduleForDate(
    LoadScheduleForDate event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(ScheduleLoading());
    
    try {
      final schedules = await getScheduleForDateUseCase(event.date);
      emit(ScheduleLoaded(
        schedules: schedules,
        selectedDate: event.date,
      ));
    } catch (e) {
      emit(ScheduleError(e.toString()));
    }
  }

  void _onLoadScheduleForWeek(
    LoadScheduleForWeek event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(ScheduleLoading());
    
    try {
      final schedules = await getScheduleForWeekUseCase(event.weekStart);
      emit(ScheduleLoaded(
        schedules: schedules,
        selectedDate: event.weekStart,
      ));
    } catch (e) {
      emit(ScheduleError(e.toString()));
    }
  }

  void _onCreateSchedule(
    CreateSchedule event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(ScheduleLoading());
    
    try {
      final createdSchedule = await createScheduleUseCase(event.schedule);
      emit(ScheduleCreated(createdSchedule));
    } catch (e) {
      emit(ScheduleError(e.toString()));
    }
  }

  void _onUpdateSchedule(
    UpdateSchedule event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(ScheduleLoading());
    
    try {
      // TODO: Implement update schedule use case
      emit(ScheduleUpdated(event.schedule));
    } catch (e) {
      emit(ScheduleError(e.toString()));
    }
  }

  void _onDeleteSchedule(
    DeleteSchedule event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(ScheduleLoading());
    
    try {
      // TODO: Implement delete schedule use case
      emit(ScheduleDeleted(event.scheduleId));
    } catch (e) {
      emit(ScheduleError(e.toString()));
    }
  }
} 