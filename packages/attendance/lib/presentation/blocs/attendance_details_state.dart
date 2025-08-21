part of 'attendance_details_bloc.dart';

abstract class AttendanceDetailsState extends Equatable {
  const AttendanceDetailsState();

  @override
  List<Object> get props => [];
}

class AttendanceDetailsInitial extends AttendanceDetailsState {}

class AttendanceDetailsLoading extends AttendanceDetailsState {}

class AttendanceDetailsLoaded extends AttendanceDetailsState {
  final AttendanceEntity attendanceDetails;

  const AttendanceDetailsLoaded(this.attendanceDetails);

  @override
  List<Object> get props => [attendanceDetails];
}

class AttendanceDetailsError extends AttendanceDetailsState {
  final String message;

  const AttendanceDetailsError(this.message);

  @override
  List<Object> get props => [message];
}
