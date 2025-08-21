import 'package:equatable/equatable.dart';

class AttendanceEntity extends Equatable {
  final int year;
  final int month;
  final int attendanceCount;
  final int absenceCount;
  final List<int> presentDays;
  final List<int> absentDays;

  const AttendanceEntity({
    required this.year,
    required this.month,
    required this.attendanceCount,
    required this.absenceCount,
    required this.presentDays,
    required this.absentDays,
  });

  @override
  List<Object?> get props => [
        year,
        month,
        attendanceCount,
        absenceCount,
        presentDays,
        absentDays,
      ];
}

class MonthlyAttendanceEntity extends Equatable {
  final String monthName;
  final int attendanceCount;
  final int absenceCount;
  final int monthNumber;

  const MonthlyAttendanceEntity({
    required this.monthName,
    required this.attendanceCount,
    required this.absenceCount,
    required this.monthNumber,
  });

  @override
  List<Object?> get props => [
        monthName,
        attendanceCount,
        absenceCount,
        monthNumber,
      ];
} 