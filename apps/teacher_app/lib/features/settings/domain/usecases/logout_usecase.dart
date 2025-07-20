import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';
import '../repositories/settings_repository.dart';
import '../entities/logout_entity.dart';

class LogoutUseCase {
  final SettingsRepository repository;
  
  LogoutUseCase(this.repository);

  Future<Either<Failure, LogoutEntity>> call(String userId) {
    return repository.logout(userId);
  }
} 