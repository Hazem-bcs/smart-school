import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_schedule_for_date_usecase.dart';
import 'schedule_event.dart';
import 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final GetScheduleForDateUseCase getScheduleForDateUseCase;

  ScheduleBloc({
    required this.getScheduleForDateUseCase,
  }) : super(ScheduleInitial()) {
    on<LoadScheduleForDate>(_onLoadScheduleForDate);
  }

  void _onLoadScheduleForDate(
    LoadScheduleForDate event,
    Emitter<ScheduleState> emit,
  ) async {
    print('🔍 ScheduleBloc: Loading schedule for date: ${event.date}');
    emit(ScheduleLoading());
    
    try {
      final schedules = await getScheduleForDateUseCase(event.date);
      print('🔍 ScheduleBloc: Received ${schedules.length} schedules');
      print('🔍 ScheduleBloc: Schedules: ${schedules.map((s) => s.title).toList()}');
      emit(ScheduleLoaded(
        schedules: schedules,
        selectedDate: event.date,
      ));
    } catch (e) {
      print('🔍 ScheduleBloc: Error loading schedule: $e');
      emit(ScheduleError(e.toString()));
    }
  }
} 