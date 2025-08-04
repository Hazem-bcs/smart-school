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
  final String image;
  final List<String> teachers;
  final List<String> notes;

  const SubjectEntity({
    required this.id,
    required this.name,
    required this.image,
    required this.teachers,
    required this.notes,
  });

  @override
  List<Object?> get props => [id, name, image, teachers, notes];
}