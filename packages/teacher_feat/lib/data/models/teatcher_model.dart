import 'package:core/data/models/subject_model.dart';

import '../../domain/teacher_entity.dart';

class TeacherModel {
  final int id;
  final String name;
  final String email;
  final String? password;
  final int specializationId;
  final int genderId;
  final String joiningDate;
  final String address;
  final int isLogged;
  final String? createdAt;
  final String? updatedAt;
  final String image;
  final String description;
  final String phone;
  final List<SubjectModel> subjectList;

  TeacherModel({
    required this.id,
    required this.name,
    required this.email,
    this.password,
    required this.specializationId,
    required this.genderId,
    required this.joiningDate,
    required this.address,
    required this.isLogged,
    this.createdAt,
    this.updatedAt,
    required this.image,
    required this.description,
    required this.phone,
    required this.subjectList,
  });

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    return TeacherModel(
      id: _parseId(json['id']),
      name: _validateName(json['name']),
      email: _validateEmail(json['email']),
      password: json['password'],
      specializationId: _parseInt(json['Specialization_id']),
      genderId: _parseInt(json['Gender_id']),
      joiningDate: _validateDate(json['Joining_Date']),
      address: _validateAddress(json['Address']),
      isLogged: _parseInt(json['is_logged']),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      image: _validateImage(json['image']),
      description: _validateDescription(json['description']),
      phone: _validatePhone(json['phone']),
      subjectList: _parseSubjects(json['subjects']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'Specialization_id': specializationId,
      'Gender_id': genderId,
      'Joining_Date': joiningDate,
      'Address': address,
      'is_logged': isLogged,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'image': image,
      'description': description,
      'phone': phone,
      'subjects': subjectList.map((subject) => subject.toJson()).toList(),
    };
  }

  TeacherEntity toEntity() {
    return TeacherEntity(
      id: id,
      name: name,
      email: email,
      specializationId: specializationId,
      genderId: genderId,
      joiningDate: joiningDate,
      address: address,
      isLogged: isLogged,
      imageUrl: image,
      description: description,
      phone: phone,
      subjects: subjectList.map((subject) => subject.toEntity()).toList(),
    );
  }

  // ============ دوال مساعدة للتحقق من الصحة ============

  static int _parseId(dynamic id) {
    if (id is int) return id;
    if (id is String) return int.tryParse(id) ?? 0;
    return 0;
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static String _validateName(dynamic name) {
    if (name is String) return name.trim();
    return 'Unknown Teacher';
  }

  static String _validateEmail(dynamic email) {
    if (email is String) return email.trim();
    return 'no-email@example.com';
  }

  static String _validateDate(dynamic date) {
    if (date is String) return date.trim();
    return 'Unknown Date';
  }

  static String _validateDescription(dynamic description) {
    if (description is String) return description.trim();
    return 'No description available';
  }

  static String _validatePhone(dynamic phone) {
    if (phone is String) return phone.trim();
    return 'No phone available';
  }

  static String _validateAddress(dynamic address) {
    if (address is String) return address.trim();
    return 'No address available';
  }

  static String _validateImage(dynamic image) {
    if (image is String && image.isNotEmpty) return image.trim();
    return 'assets/images/user.png'; // Default image
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
    return 'TeacherModel(id: $id, name: $name, email: $email, subjects: ${subjectList.length})';
  }
}
