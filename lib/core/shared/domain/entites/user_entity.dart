import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int? id;
  final String email;
  final String password;
  final String? token;
  final String? name;
  final String? profilePhotoUrl;

  const UserEntity({
    required this.id,
    required this.email,
    required this.password,
    this.token,
    this.name,
    this.profilePhotoUrl,
  });

  @override
  List<Object?> get props => [id,email, password, token, name, profilePhotoUrl];
}