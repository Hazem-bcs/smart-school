import '../../domain/entities/subject_entity.dart';

class SubjectModel {
  final int id;
  final String name;
  final String image;
  final List<String> teachers;
  final List<String> notes;

  SubjectModel({
    required this.id,
    required this.name,
    required this.image,
    required this.teachers,
    required this.notes,
  });

  // من JSON إلى Model
  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      teachers: List<String>.from(json['teachers']),
      notes: List<String>.from(json['notes']),
    );
  }

  // من Model إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'teachers': teachers,
      'notes': notes,
    };
  }

  SubjectEntity toEntity() {
    return SubjectEntity(
      id: id,
      name: name,
      image: image,
      teachers: teachers,
      notes: notes,
    );
  }
}
