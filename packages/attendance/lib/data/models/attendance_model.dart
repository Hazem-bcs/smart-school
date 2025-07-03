import 'dart:convert';
import '../../domain/entities/attendance_entity.dart';

class AttendanceModel extends AttendanceEntity {
  AttendanceModel({
    required super.year,
    required super.month,
    required super.attendanceCount,
    required super.absenceCount,
    required super.presentDays,
    required super.absentDays,
  });

  AttendanceModel copyWith({
    int? year,
    int? month,
    int? attendanceCount,
    int? absenceCount,
    List<int>? presentDays,
    List<int>? absentDays,
  }) {
    return AttendanceModel(
      year: year ?? this.year,
      month: month ?? this.month,
      attendanceCount: attendanceCount ?? this.attendanceCount,
      absenceCount: absenceCount ?? this.absenceCount,
      presentDays: presentDays ?? this.presentDays,
      absentDays: absentDays ?? this.absentDays,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'year': year,
      'month': month,
      'attendanceCount': attendanceCount,
      'absenceCount': absenceCount,
      'presentDays': presentDays,
      'absentDays': absentDays,
    };
  }

  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    return AttendanceModel(
      year: map['year'] as int,
      month: map['month'] as int,
      attendanceCount: map['attendanceCount'] as int,
      absenceCount: map['absenceCount'] as int,
      presentDays: List<int>.from(map['presentDays'] as List),
      absentDays: List<int>.from(map['absentDays'] as List),
    );
  }

  String toJson() => json.encode(toMap());

  factory AttendanceModel.fromJson(String source) =>
      AttendanceModel.fromMap(json.decode(source) as Map<String, dynamic>);

  // Convert Model to Entity
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

  // Create Model from Entity
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
}

class MonthlyAttendanceModel extends MonthlyAttendanceEntity {
  MonthlyAttendanceModel({
    required super.monthName,
    required super.attendanceCount,
    required super.absenceCount,
    required super.monthNumber,
  });

  MonthlyAttendanceModel copyWith({
    String? monthName,
    int? attendanceCount,
    int? absenceCount,
    int? monthNumber,
  }) {
    return MonthlyAttendanceModel(
      monthName: monthName ?? this.monthName,
      attendanceCount: attendanceCount ?? this.attendanceCount,
      absenceCount: absenceCount ?? this.absenceCount,
      monthNumber: monthNumber ?? this.monthNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'monthName': monthName,
      'attendanceCount': attendanceCount,
      'absenceCount': absenceCount,
      'monthNumber': monthNumber,
    };
  }

  factory MonthlyAttendanceModel.fromMap(Map<String, dynamic> map) {
    return MonthlyAttendanceModel(
      monthName: map['monthName'] as String,
      attendanceCount: map['attendanceCount'] as int,
      absenceCount: map['absenceCount'] as int,
      monthNumber: map['monthNumber'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory MonthlyAttendanceModel.fromJson(String source) =>
      MonthlyAttendanceModel.fromMap(json.decode(source) as Map<String, dynamic>);

  // Convert Model to Entity
  MonthlyAttendanceEntity toEntity() {
    return MonthlyAttendanceEntity(
      monthName: monthName,
      attendanceCount: attendanceCount,
      absenceCount: absenceCount,
      monthNumber: monthNumber,
    );
  }

  // Create Model from Entity
  factory MonthlyAttendanceModel.fromEntity(MonthlyAttendanceEntity entity) {
    return MonthlyAttendanceModel(
      monthName: entity.monthName,
      attendanceCount: entity.attendanceCount,
      absenceCount: entity.absenceCount,
      monthNumber: entity.monthNumber,
    );
  }
} 