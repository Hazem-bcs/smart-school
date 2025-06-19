import '../../domain/subject_entity.dart';

class SubjectModel {
  final int id;
  final String name;
  final String image;

  SubjectModel({
    required this.id,
    required this.name,
    required this.image,
  });

  // من JSON إلى Model
  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }

  // من Model إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
    };
  }

  SubjectEntity toEntity() {
    return SubjectEntity(
      id: id,
      name: name,
      image: image,
    );
  }
}