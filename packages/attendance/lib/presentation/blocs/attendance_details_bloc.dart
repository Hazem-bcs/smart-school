import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/attendance_entity.dart';
import '../../domain/usecases/get_attendance_details_use_case.dart';

part 'attendance_details_event.dart';
part 'attendance_details_state.dart';

class AttendanceDetailsBloc extends Bloc<AttendanceDetailsEvent, AttendanceDetailsState> {
  final GetAttendanceDetailsUseCase getAttendanceDetailsUseCase;

  AttendanceDetailsBloc({
    required this.getAttendanceDetailsUseCase,
  }) : super(AttendanceDetailsInitial()) {
    on<LoadAttendanceDetailsEvent>(_onLoadAttendanceDetails);
  }

  Future<void> _onLoadAttendanceDetails(
    LoadAttendanceDetailsEvent event,
    Emitter<AttendanceDetailsState> emit,
  ) async {
    emit(AttendanceDetailsLoading());
    final result = await getAttendanceDetailsUseCase(event.year, event.month);
    result.fold(
      (failure) => emit(AttendanceDetailsError(failure.toString())),
      (data) => emit(AttendanceDetailsLoaded(data)),
    );
  }
}
