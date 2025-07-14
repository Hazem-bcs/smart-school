import 'package:dartz/dartz.dart';
import '../entities/user.dart';
import '../entities/auth_response.dart';

abstract class AuthRepository {
  Future<Either<String, AuthResponse>> login(String email, String password);
  Future<Either<String, User>> checkAuthStatus();
  Future<void> logout();
  Future<String?> getStoredToken();
  Future<User?> getStoredUser();
} 