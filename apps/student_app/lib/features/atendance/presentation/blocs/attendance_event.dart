part of 'attendance_bloc.dart';

@immutable
sealed class AttendanceEvent {}

class LoadMonthlyAttendance extends AttendanceEvent {
  final int year;
  LoadMonthlyAttendance(this.year);
}

class LoadAttendanceDetails extends AttendanceEvent {
  final int year;
  final int month;
  LoadAttendanceDetails(this.year, this.month);
}
