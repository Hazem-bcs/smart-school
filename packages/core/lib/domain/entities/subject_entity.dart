// class SubjectEntity {
//   final int id;
//   final String name;
//   final String image;
//
//   SubjectEntity({
//     required this.id,
//     required this.name,
//     required this.image,
//   });
// }

import 'package:equatable/equatable.dart';

class SubjectEntity extends Equatable {
  final int id;
  final String name;
  final String grade;
  final String classroom;
  final String? teacher;

  const SubjectEntity({
    required this.id,
    required this.name,
    required this.grade,
    required this.classroom,
    this.teacher,
  });

  @override
  List<Object?> get props => [id, name, grade, classroom, teacher];
}