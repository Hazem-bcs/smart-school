import 'package:dartz/dartz.dart';

import '../../../../core/network/failures.dart';
import '../auth_repository.dart';
import '../entites/user_entity.dart';

class CheckAuthStatusUseCase {
  final AuthRepository repository;

  CheckAuthStatusUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call() async {
    return await repository.checkAuthStatus();
  }
}