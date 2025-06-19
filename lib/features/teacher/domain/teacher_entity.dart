
import '../../subject/domain/subject_entity.dart';

class TeacherEntity {
  final int id;
  final String name;
  final String imageUrl;
  final String description;
  final String phone;
  final String address;
  final List<SubjectEntity> subjects;

  TeacherEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.phone,
    required this.address,
    required this.subjects,
  });
}