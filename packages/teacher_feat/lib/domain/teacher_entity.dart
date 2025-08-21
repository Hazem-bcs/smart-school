

import 'package:core/domain/entities/subject_entity.dart';

class TeacherEntity {
  final int id;
  final String name;
  final String email;
  final int specializationId;
  final int genderId;
  final String joiningDate;
  final String address;
  final int isLogged;
  final String imageUrl;
  final String description;
  final String phone;
  final List<SubjectEntity> subjects;

  TeacherEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.specializationId,
    required this.genderId,
    required this.joiningDate,
    required this.address,
    required this.isLogged,
    required this.imageUrl,
    required this.description,
    required this.phone,
    required this.subjects,
  });
}