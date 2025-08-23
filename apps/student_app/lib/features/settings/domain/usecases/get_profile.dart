
import 'package:core/domain/entities/user_entity.dart';
import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';

import '../repositories/settings_repository.dart';

class GetProfileUseCase{
  final SettingsRepository repository;

  GetProfileUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call() async {
    return await repository.getStudentProfile();
  }
}