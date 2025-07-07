import 'package:dartz/dartz.dart';
import '../entities/password_change_request.dart';
import '../repositories/password_repository.dart';

class ChangePasswordUseCase {
  final PasswordRepository repository;

  ChangePasswordUseCase(this.repository);

  Future<Either<String, void>> call(PasswordChangeRequest request) async {
    return await repository.changePassword(request);
  }
} 