import '../../domain/entities/attendance_trend_entity.dart';

class AttendanceTrendModel extends AttendanceTrendEntity {
  const AttendanceTrendModel({
    required super.startDate,
    required super.codes,
  });

  factory AttendanceTrendModel.fromJson(Map<String, dynamic> json) {
    return AttendanceTrendModel(
      startDate: DateTime.parse(json['start_date'] as String),
      codes: (json['codes'] as List).map((e) => (e as num).toInt()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'start_date': startDate.toIso8601String().substring(0, 10),
      'codes': codes,
    };
  }
}
