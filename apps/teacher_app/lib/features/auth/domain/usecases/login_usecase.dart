import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:teacher_app/features/auth/domain/entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, User>> call(String email, String password) async {
    return await repository.login(email, password);
  }
} 