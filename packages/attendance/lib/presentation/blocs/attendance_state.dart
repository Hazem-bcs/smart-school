part of 'attendance_bloc.dart';

@immutable
sealed class AttendanceState {}

final class AttendanceInitial extends AttendanceState {}

class AttendanceLoading extends AttendanceState {}

class MonthlyAttendanceLoaded extends AttendanceState {
  final List<MonthlyAttendanceEntity> monthlyAttendance;
  MonthlyAttendanceLoaded(this.monthlyAttendance);
}



class AttendanceError extends AttendanceState {
  final String message;
  AttendanceError(this.message);
}
