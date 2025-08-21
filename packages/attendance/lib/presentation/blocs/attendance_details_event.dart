part of 'attendance_details_bloc.dart';

abstract class AttendanceDetailsEvent extends Equatable {
  const AttendanceDetailsEvent();

  @override
  List<Object> get props => [];
}

class LoadAttendanceDetailsEvent extends AttendanceDetailsEvent {
  final int year;
  final int month;

  const LoadAttendanceDetailsEvent({
    required this.year,
    required this.month,
  });

  @override
  List<Object> get props => [year, month];
}
