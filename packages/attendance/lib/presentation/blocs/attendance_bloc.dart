import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import '../../domain/entities/attendance_entity.dart';
import '../../domain/usecases/get_monthly_attendance_use_case.dart';


part 'attendance_event.dart';
part 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final GetMonthlyAttendanceUseCase getMonthlyAttendanceUseCase;

  AttendanceBloc({
    required this.getMonthlyAttendanceUseCase,
  }) : super(AttendanceInitial()) {
    on<LoadMonthlyAttendance>(_onLoadMonthlyAttendance);
  }

  Future<void> _onLoadMonthlyAttendance(
    LoadMonthlyAttendance event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(AttendanceLoading());
    final result = await getMonthlyAttendanceUseCase(event.year);
    result.fold(
      (failure) => emit(AttendanceError(failure.toString())),
      (data) => emit(MonthlyAttendanceLoaded(data)),
    );
  }


}

