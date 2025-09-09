import '../../domain/entities/attendance_entity.dart';

class AttendanceModel extends AttendanceEntity {
  const AttendanceModel({
    required super.year,
    required super.month,
    required super.attendanceCount,
    required super.absenceCount,
    required super.presentDays,
    required super.absentDays,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic v) => v is int ? v : int.tryParse('$v') ?? 0;
    List<int> parseIntList(dynamic v) {
      if (v == null) return <int>[];
      if (v is List) {
        return v.map((e) => parseInt(e)).toList();
      }
      return <int>[];
    }

    return AttendanceModel(
      year: parseInt(json['year']),
      month: parseInt(json['month']),
      attendanceCount: parseInt(json['attendanceCount']),
      absenceCount: parseInt(json['absenceCount']),
      presentDays: parseIntList(json['presentDays']),
      absentDays: parseIntList(json['absentDays']),
    );
  }

  factory AttendanceModel.fromEntity(AttendanceEntity entity) {
    return AttendanceModel(
      year: entity.year,
      month: entity.month,
      attendanceCount: entity.attendanceCount,
      absenceCount: entity.absenceCount,
      presentDays: entity.presentDays,
      absentDays: entity.absentDays,
    );
  }

  AttendanceEntity toEntity() {
    return AttendanceEntity(
      year: year,
      month: month,
      attendanceCount: attendanceCount,
      absenceCount: absenceCount,
      presentDays: presentDays,
      absentDays: absentDays,
    );
  }
}

class MonthlyAttendanceModel extends MonthlyAttendanceEntity {
  const MonthlyAttendanceModel({
    required super.monthName,
    required super.attendanceCount,
    required super.absenceCount,
    required super.monthNumber,
  });

  factory MonthlyAttendanceModel.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic v) => v is int ? v : int.tryParse('$v') ?? 0;
    return MonthlyAttendanceModel(
      monthName: (json['monthName'] ?? json['month_name'] ?? '') as String,
      attendanceCount: parseInt(json['attendanceCount'] ?? json['present_days'] ?? json['present'] ?? 0),
      absenceCount: parseInt(json['absenceCount'] ?? json['absent_days'] ?? json['absent'] ?? 0),
      monthNumber: parseInt(json['monthNumber'] ?? json['month'] ?? 0),
    );
  }

  MonthlyAttendanceEntity toEntity() {
    return MonthlyAttendanceEntity(
      monthName: monthName,
      attendanceCount: attendanceCount,
      absenceCount: absenceCount,
      monthNumber: monthNumber,
    );
  }

  factory MonthlyAttendanceModel.fromEntity(MonthlyAttendanceEntity entity) {
    return MonthlyAttendanceModel(
      monthName: entity.monthName,
      attendanceCount: entity.attendanceCount,
      absenceCount: entity.absenceCount,
      monthNumber: entity.monthNumber,
    );
  }
}