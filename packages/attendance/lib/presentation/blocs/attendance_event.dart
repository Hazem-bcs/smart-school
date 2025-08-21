part of 'attendance_bloc.dart';

@immutable
sealed class AttendanceEvent {}

class LoadMonthlyAttendance extends AttendanceEvent {
  final int year;
  LoadMonthlyAttendance(this.year);
}


