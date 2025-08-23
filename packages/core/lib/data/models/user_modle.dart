import 'package:core/domain/entities/user_entity.dart';

class UserModel {
  final int? id;
  final String email;
  final String password;
  final String? token;
  final String? name;
  final String? profilePhotoUrl;
  final String? gender;
  final String? nationality;
  final String? dateBirth;
  final String? grade;
  final String? classroom;
  final String? section;
  final String? fatherName;
  final String? motherName;
  final String? address;
  final String? phone;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.profilePhotoUrl,
    required this.token,
    this.gender,
    this.nationality,
    this.dateBirth,
    this.grade,
    this.classroom,
    this.section,
    this.fatherName,
    this.motherName,
    this.address,
    this.phone,
  });


  factory UserModel.fromLaravelResponse(Map<String, dynamic> response) {
    final dynamic data = response['data'];

    if (data == null) {
      throw Exception('Invalid response format: data is null');
    }

    if (data is List) {
      if (data.isEmpty) {
        throw Exception('لا يوجد بيانات مستخدم في الاستجابة');
      }
      final userData = data.first as Map<String, dynamic>;
      return UserModel(
        id: userData['id'] as int?,
        name: userData['name'] as String?,
        email: userData['email'] as String? ?? '',
        password: '', 
        profilePhotoUrl: null,
        token: null,
        gender: userData['gender'] as String?,
        nationality: userData['nationality'] as String?,
        dateBirth: userData['date_birth'] as String?,
        grade: userData['grade'] as String?,
        classroom: userData['classroom'] as String?,
        section: userData['section'] as String?,
        fatherName: userData['father_name'] as String?,
        motherName: userData['mother_name'] as String?,
        address: userData['address'] as String?,
        phone: userData['phone'] as String?,
      );
    }

    if (data is Map<String, dynamic>) {
      return UserModel(
        id: data['id'] as int?,
        name: data['name'] as String?,
        email: data['email'] as String? ?? '',
        password: '',
        profilePhotoUrl: null,
        token: null,
        gender: data['gender'] as String?,
        nationality: data['nationality'] as String?,
        dateBirth: data['date_birth'] as String?,
        grade: data['grade'] as String?,
        classroom: data['classroom'] as String?,
        section: data['section'] as String?,
        fatherName: data['father_name'] as String?,
        motherName: data['mother_name'] as String?,
        address: data['address'] as String?,
        phone: data['phone'] as String?,
      );
    }

    throw Exception('Invalid response format: data is not a Map or List');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profile_photo_url': profilePhotoUrl,
      'token': token,
      'gender': gender,
      'nationality': nationality,
      'date_birth': dateBirth,
      'grade': grade,
      'classroom': classroom,
      'section': section,
      'father_name': fatherName,
      'mother_name': motherName,
      'address': address,
      'phone': phone,
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      password: password,
      name: name,
      email: email,
      profilePhotoUrl: profilePhotoUrl,
      token: token,
      gender: gender,
      nationality: nationality,
      dateBirth: dateBirth,
      grade: grade,
      classroom: classroom,
      section: section,
      fatherName: fatherName,
      motherName: motherName,
      address: address,
      phone: phone,
    );
  }
}