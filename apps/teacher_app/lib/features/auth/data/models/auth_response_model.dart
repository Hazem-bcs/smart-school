import 'user_model.dart';
import '../../domain/entities/auth_response.dart';

class AuthResponseModel {
  final String token;
  final String refreshToken;
  final UserModel user;
  final DateTime expiresAt;

  AuthResponseModel({
    required this.token,
    required this.refreshToken,
    required this.user,
    required this.expiresAt,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    // Handle different date formats and provide fallback
    DateTime expiresAt;
    if (json['expires_at'] != null) {
      expiresAt = DateTime.parse(json['expires_at'] as String);
    } else if (json['expires_in'] != null) {
      // If expires_in is provided (seconds), calculate expires_at
      final expiresInSeconds = json['expires_in'] as int;
      expiresAt = DateTime.now().add(Duration(seconds: expiresInSeconds));
    } else {
      // Default to 1 hour from now
      expiresAt = DateTime.now().add(const Duration(hours: 1));
    }

    return AuthResponseModel(
      token: json['token'] as String? ?? '',
      refreshToken: json['refresh_token'] as String? ?? '',
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>? ?? {}),
      expiresAt: expiresAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'refresh_token': refreshToken,
      'user': user.toJson(),
      'expires_at': expiresAt.toIso8601String(),
    };
  }

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  AuthResponseModel copyWith({
    String? token,
    String? refreshToken,
    UserModel? user,
    DateTime? expiresAt,
  }) {
    return AuthResponseModel(
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
      user: user ?? this.user,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  // Convert model to entity
  AuthResponse toEntity() {
    return AuthResponse(
      token: token,
      refreshToken: refreshToken,
      user: user.toEntity(),
      expiresAt: expiresAt,
    );
  }
} 