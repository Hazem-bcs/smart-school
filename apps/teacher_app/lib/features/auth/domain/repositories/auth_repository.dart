import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:teacher_app/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, bool>> checkAuthStatus();
  Future<Either<Failure, void>> logout();
} 