import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:attendance/domain/entities/attendance_entity.dart';
import 'package:attendance/domain/usecases/get_monthly_attendance_use_case.dart';
import 'package:attendance/domain/usecases/get_attendance_details_use_case.dart';

part 'attendance_event.dart';
part 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final GetMonthlyAttendanceUseCase getMonthlyAttendanceUseCase;
  final GetAttendanceDetailsUseCase getAttendanceDetailsUseCase;

  AttendanceBloc({required this.getMonthlyAttendanceUseCase, required this.getAttendanceDetailsUseCase}) : super(AttendanceInitial()) {
    on<LoadMonthlyAttendance>(_onLoadMonthlyAttendance);
    on<LoadAttendanceDetails>(_onLoadAttendanceDetails);
  }

  Future<void> _onLoadMonthlyAttendance(LoadMonthlyAttendance event, Emitter<AttendanceState> emit) async {
    emit(AttendanceLoading());
    final result = await getMonthlyAttendanceUseCase(event.year);
    result.fold(
      (failure) => emit(AttendanceError(failure.toString())),
      (data) => emit(MonthlyAttendanceLoaded(data)),
    );
  }

  Future<void> _onLoadAttendanceDetails(LoadAttendanceDetails event, Emitter<AttendanceState> emit) async {
    emit(AttendanceLoading());
    final result = await getAttendanceDetailsUseCase(event.year, event.month);
    result.fold(
      (failure) => emit(AttendanceError(failure.toString())),
      (data) => emit(AttendanceDetailsLoaded(data)),
    );
  }
}
