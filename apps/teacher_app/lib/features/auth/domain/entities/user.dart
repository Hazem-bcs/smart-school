class User {
  final String id;
  final String email;
  final String name;
  final String role;
  final String? avatar;
  final String? phone;
  final String? department;
  final int? experienceYears;
  final String? qualification;
  final String? bio;
  final DateTime createdAt;
  final DateTime? lastLoginAt;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.avatar,
    this.phone,
    this.department,
    this.experienceYears,
    this.qualification,
    this.bio,
    required this.createdAt,
    this.lastLoginAt,
  });

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? role,
    String? avatar,
    String? phone,
    String? department,
    int? experienceYears,
    String? qualification,
    String? bio,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      avatar: avatar ?? this.avatar,
      phone: phone ?? this.phone,
      department: department ?? this.department,
      experienceYears: experienceYears ?? this.experienceYears,
      qualification: qualification ?? this.qualification,
      bio: bio ?? this.bio,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }
} 