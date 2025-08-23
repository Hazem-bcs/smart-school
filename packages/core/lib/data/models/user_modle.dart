import 'package:core/domain/entities/user_entity.dart';

class UserModel {
  final int? id;
  final String email;
  final String password;
  final String? token;
  final String? name;
  final String? profilePhotoUrl;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.profilePhotoUrl,
    required this.token,
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
    );
  }
}