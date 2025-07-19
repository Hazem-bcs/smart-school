import '../../domain/entities/user.dart';

class UserModel {
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

  UserModel({
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

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final id = json['id']?.toString() ?? '1';
    final email = json['email'] as String? ?? '';
    final name = json['name'] as String? ?? 'معلم تجريبي';
    final role = json['role'] as String? ?? 'teacher';
    final avatar = json['avatar'] as String? ?? json['profile_photo'] as String? ?? 'https://example.com/default-avatar.jpg';
    final phone = json['phone'] as String?;
    final department = json['department'] as String?;
    final experienceYears = json['experience_years'] is int ? json['experience_years'] as int : int.tryParse(json['experience_years']?.toString() ?? '');
    final qualification = json['qualification'] as String?;
    final bio = json['bio'] as String?;
    DateTime createdAt;
    try {
      createdAt = DateTime.parse(json['created_at'] as String);
    } catch (e) {
      createdAt = DateTime.now();
    }
    DateTime? lastLoginAt;
    try {
      if (json['last_login_at'] != null) {
        lastLoginAt = DateTime.parse(json['last_login_at'] as String);
      }
    } catch (e) {
      lastLoginAt = null;
    }
    return UserModel(
      id: id,
      email: email,
      name: name,
      role: role,
      avatar: avatar,
      phone: phone,
      department: department,
      experienceYears: experienceYears,
      qualification: qualification,
      bio: bio,
      createdAt: createdAt,
      lastLoginAt: lastLoginAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role,
      'avatar': avatar,
      'phone': phone,
      'department': department,
      'experience_years': experienceYears,
      'qualification': qualification,
      'bio': bio,
      'created_at': createdAt.toIso8601String(),
      'last_login_at': lastLoginAt?.toIso8601String(),
    };
  }

  UserModel copyWith({
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
    return UserModel(
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

  // Convert model to entity
  User toEntity() {
    return User(
      id: id,
      email: email,
      name: name,
      role: role,
      avatar: avatar,
      phone: phone,
      department: department,
      experienceYears: experienceYears,
      qualification: qualification,
      bio: bio,
      createdAt: createdAt,
      lastLoginAt: lastLoginAt,
    );
  }
} 