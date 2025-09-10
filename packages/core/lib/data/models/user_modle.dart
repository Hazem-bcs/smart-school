import 'package:core/domain/entities/user_entity.dart';
import 'package:core/constant.dart';

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
    String? _asString(dynamic value) {
      if (value == null) return null;
      if (value is String) return value;
      // If backend returns nested object for a field, prefer a common 'name' key
      if (value is Map<String, dynamic>) {
        final dynamic maybeName = value['name'] ?? value['title'] ?? value['value'];
        return maybeName?.toString() ?? value.toString();
      }
      return value.toString();
    }

    int? _asInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      return int.tryParse(value.toString());
    }

    String? _resolveImageUrl(dynamic rawImage) {
      if (rawImage == null) return null;
      final String str = _asString(rawImage) ?? '';
      if (str.isEmpty) return null;
      if (str.startsWith('http')) return str;
      return Constants.baseUrl + str;
    }

    final dynamic data = response['data'];

    if (data == null) {
      throw Exception('Invalid response format: data is null');
    }

    Map<String, dynamic> _extractUserMap(dynamic input) {
      if (input is List) {
        if (input.isEmpty) {
          throw Exception('لا يوجد بيانات مستخدم في الاستجابة');
        }
        final first = input.first;
        if (first is Map<String, dynamic>) return first;
        throw Exception('Invalid response format: first item is not an object');
      }
      if (input is Map<String, dynamic>) return input;
      throw Exception('Invalid response format: data is not a Map or List');
    }

    final Map<String, dynamic> userData = _extractUserMap(data);

    final dynamic rawImage = userData['profile_photo_url'] ?? userData['image'] ?? userData['avatar'] ?? userData['photo'];
    final String? resolvedPhotoUrl = _resolveImageUrl(rawImage);

    return UserModel(
      id: _asInt(userData['id']),
      name: _asString(userData['name']),
      email: _asString(userData['email']) ?? '',
      password: '',
      profilePhotoUrl: resolvedPhotoUrl,
      token: _asString(userData['token']),
      gender: _asString(userData['gender']),
      nationality: _asString(userData['nationality']),
      dateBirth: _asString(userData['date_birth'] ?? userData['dateBirth']),
      grade: _asString(userData['grade']),
      classroom: _asString(userData['classroom']),
      section: _asString(userData['section']),
      fatherName: _asString(userData['father_name'] ?? userData['fatherName']),
      motherName: _asString(userData['mother_name'] ?? userData['motherName']),
      address: _asString(userData['address']),
      phone: _asString(userData['phone']),
    );
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