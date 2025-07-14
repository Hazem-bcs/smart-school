import 'user.dart';

class AuthResponse {
  final String token;
  final String refreshToken;
  final User user;
  final DateTime expiresAt;

  AuthResponse({
    required this.token,
    required this.refreshToken,
    required this.user,
    required this.expiresAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  AuthResponse copyWith({
    String? token,
    String? refreshToken,
    User? user,
    DateTime? expiresAt,
  }) {
    return AuthResponse(
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
      user: user ?? this.user,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }
} 