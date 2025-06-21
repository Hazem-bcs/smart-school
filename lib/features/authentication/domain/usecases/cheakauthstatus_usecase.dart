import 'package:dartz/dartz.dart';

import '../../../../core/network/failures.dart';
import '../auth_repository.dart';

class CheckAuthStatusUseCase {
  final AuthRepository repository;

  CheckAuthStatusUseCase(this.repository);

  Future<Either<Failure, bool>> call() async {
    return await repository.checkAuthStatus();
  }
}