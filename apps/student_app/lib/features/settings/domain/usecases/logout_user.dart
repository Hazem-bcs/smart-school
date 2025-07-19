// lib/features/settings/domain/usecases/logout_user.dart

import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';

import '../../../../widgets/usecases/usecase.dart';
import '../entities/logout_status_entity.dart';
import '../repositories/settings_repository.dart';

class LogoutUser implements UseCase<LogoutStatusEntity, NoParams> {
  final SettingsRepository repository;

  LogoutUser(this.repository);

  @override
  Future<Either<Failure, LogoutStatusEntity>> call(NoParams params) async {
    print('🟣 LogoutUser Use Case: executing logout.');
    return await repository.logout();
  }
}