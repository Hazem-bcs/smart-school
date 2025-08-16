import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';

import '../auth_repository.dart';

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.logout();
  }
}
