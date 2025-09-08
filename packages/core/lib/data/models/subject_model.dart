import '../../domain/entities/subject_entity.dart';

class SubjectModel {
  final int id;
  final String name;
  final String grade;
  final String classroom;
  final String? teacher;

  SubjectModel({
    required this.id,
    required this.name,
    required this.grade,
    required this.classroom,
    this.teacher,
  });

  // مرن: يدعم صيغ متنوعة قادمة من باك-إند مختلف
  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: (json['id'] ?? 0) is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      name: (json['name'] ?? json['subject_name'] ?? 'غير معروف') as String,
      grade: (json['grade'] ?? '') as String,
      classroom: (json['classroom'] ?? '') as String,
      teacher: (json['teacher'] ?? json['teacher_name']) as String?,
    );
  }

  // من JSON (قائمة المواد)
  factory SubjectModel.fromListJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['id'] as int,
      name: json['name'] as String,
      grade: json['grade'] as String,
      classroom: json['classroom'] as String,
      teacher: json['teacher'] as String?,
    );
  }

  // من JSON (تفاصيل مادة)
  factory SubjectModel.fromDetailJson(Map<String, dynamic> json, {required int id}) {
    return SubjectModel(
      id: id,
      name: (json['subject_name'] ?? json['name']) as String,
      grade: (json['grade']) as String,
      classroom: (json['classroom']) as String,
      teacher: (json['teacher_name'] ?? json['teacher']) as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'grade': grade,
      'classroom': classroom,
      'teacher': teacher,
    };
  }

  SubjectEntity toEntity() {
    return SubjectEntity(
      id: id,
      name: name,
      grade: grade,
      classroom: classroom,
      teacher: teacher,
    );
  }
}
