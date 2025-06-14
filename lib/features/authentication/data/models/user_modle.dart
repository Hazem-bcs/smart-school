import '../../domain/entites/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    super.name,
    required super.email,
    required super.password,
    super.profilePhotoUrl,
    super.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] as String?,
      email: json['email'] as String,
      password: json['password'] as String,
      profilePhotoUrl: json['profile_photo_url'] as String?,
      token: json['token'] as String?, // 'token' is added to user object in PHP login
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'profile_photo_url': profilePhotoUrl,
      'token': token,
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      password: password,
      name: name,
      email: email,
      profilePhotoUrl: profilePhotoUrl,
      token: token,
    );
  }

}