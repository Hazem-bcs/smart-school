import 'package:core/domain/entities/user_entity.dart';

class UserModel{

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

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      email: json['email'] as String,
      password: json['password'] as String? ?? '',
      profilePhotoUrl: json['profile_photo_url'] as String?,
      token: json['token'] as String?,
    );
  }

  // Factory method for Laravel API response
  factory UserModel.fromLaravelResponse(Map<String, dynamic> response) {
    final data = response['data'] as Map<String, dynamic>?;
    if (data == null) {
      throw Exception('Invalid response format');
    }
    
    return UserModel(
      id: data['id'] as int?,
      name: data['name'] as String?,
      email: data['email'] as String,
      password: '', // لا نستقبل كلمة المرور من السيرفر
      profilePhotoUrl: null, // يمكن إضافته لاحقاً
      token: null, // يمكن إضافته لاحقاً
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
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