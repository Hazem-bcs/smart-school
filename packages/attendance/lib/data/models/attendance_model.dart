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
    return AttendanceModel(
      year: json['year'] as int,
      month: json['month'] as int,
      attendanceCount: json['attendanceCount'] as int,
      absenceCount: json['absenceCount'] as int,
      presentDays: List<int>.from(json['presentDays'] as List),
      absentDays: List<int>.from(json['absentDays'] as List),
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
    return MonthlyAttendanceModel(
      monthName: json['monthName'] as String,
      attendanceCount: json['attendanceCount'] as int,
      absenceCount: json['absenceCount'] as int,
      monthNumber: json['monthNumber'] as int,
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