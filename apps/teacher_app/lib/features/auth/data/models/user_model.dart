import '../../domain/entities/user.dart';

class UserModel {
  final String id;
  final String email;
  final String name;
  final String role;
  final String? avatar;
  final DateTime createdAt;
  final DateTime? lastLoginAt;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.avatar,
    required this.createdAt,
    this.lastLoginAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Handle different field names and provide fallbacks
    final id = json['id']?.toString() ?? '1';
    final email = json['email'] as String? ?? '';
    final name = json['name'] as String? ?? 'معلم تجريبي';
    final role = json['role'] as String? ?? 'teacher';
    
    // Handle different avatar field names
    final avatar = json['avatar'] as String? ?? 
                   json['profile_photo'] as String? ?? 
                   'https://example.com/default-avatar.jpg';
    
    // Handle different date formats and provide fallbacks
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
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      avatar: avatar ?? this.avatar,
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
      createdAt: createdAt,
      lastLoginAt: lastLoginAt,
    );
  }
} 