class AttendanceEntity {
  final int year;
  final int month;
  final int attendanceCount;
  final int absenceCount;
  final List<int> presentDays;
  final List<int> absentDays;

  AttendanceEntity({
    required this.year,
    required this.month,
    required this.attendanceCount,
    required this.absenceCount,
    required this.presentDays,
    required this.absentDays,
  });
}

class MonthlyAttendanceEntity {
  final String monthName;
  final int attendanceCount;
  final int absenceCount;
  final int monthNumber;

  MonthlyAttendanceEntity({
    required this.monthName,
    required this.attendanceCount,
    required this.absenceCount,
    required this.monthNumber,
  });
} 