import 'package:smart_school/features/subject/data/models/subject_model.dart';

import '../../domain/teacher_entity.dart';

class TeacherModel {
  final int id;
  final String name;
  final String image;
  final String description;
  final String phone;
  final String address;
  final List<SubjectModel> subjectList;

  TeacherModel({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.phone,
    required this.address,
    required this.subjectList,
  });

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    return TeacherModel(
      id: _parseId(json['id']),
      name: _validateName(json['name']),
      image: json['image'],
      phone: json['phone'],
      address: json['address'],
      description: _validateDescription(json['description']),
      subjectList: _parseSubjects(json['subjects']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'description': description,
      'subjects': subjectList.map((subject) => subject.toJson()).toList(),
    };
  }

  TeacherEntity toEntity() {
    return TeacherEntity(
      id: id,
      name: name,
      imageUrl: image,
      phone: phone,
      address: address,
      description: description,
      subjects: subjectList.map((subject) => subject.toEntity()).toList(),
    );
  }

  // ============ دوال مساعدة للتحقق من الصحة ============

  static int _parseId(dynamic id) {
    if (id is int) return id;
    if (id is String) return int.tryParse(id) ?? 0;
    return 0;
  }

  static String _validateName(dynamic name) {
    if (name is String) return name.trim();
    return 'Unknown Teacher';
  }


  static String _validateDescription(dynamic description) {
    if (description is String) return description.trim();
    return 'No description available';
  }

  static List<SubjectModel> _parseSubjects(dynamic subjects) {
    if (subjects is List) {
      return subjects
          .whereType<Map<String, dynamic>>()
          .map((subject) => SubjectModel.fromJson(subject))
          .toList();
    }
    return [];
  }

  @override
  String toString() {
    return 'TeacherModel(id: $id, name: $name, subjects: ${subjectList.length})';
  }
}