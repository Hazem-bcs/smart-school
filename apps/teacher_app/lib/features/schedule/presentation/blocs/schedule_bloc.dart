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

  Future<void> _onLoadScheduleForDate(
    LoadScheduleForDate event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(ScheduleLoading());
    
    final result = await getScheduleForDateUseCase(event.date);
    result.fold(
      (failure) => emit(ScheduleError(failure.message)),
      (schedules) => emit(ScheduleLoaded(
        schedules: schedules,
        selectedDate: event.date,
      )),
    );
  }
} 