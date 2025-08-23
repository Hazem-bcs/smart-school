
class UserEntity {
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

  const UserEntity({
    required this.id,
    required this.email,
    required this.password,
    this.token,
    this.name,
    this.profilePhotoUrl,
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
}