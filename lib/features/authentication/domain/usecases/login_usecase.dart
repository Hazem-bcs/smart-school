import 'package:dartz/dartz.dart';

import '../../../../core/network/failures.dart';
import '../../../../core/shared/domain/entites/user_entity.dart';
import '../auth_repository.dart';

class LoginUseCase{
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(String email, String password) async {
    return await repository.login(
      email: email,
      password: password,
    );
  }
}