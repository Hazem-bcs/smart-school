
class UserEntity {
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
}