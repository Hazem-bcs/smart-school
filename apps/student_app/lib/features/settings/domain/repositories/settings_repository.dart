// lib/features/settings/domain/repositories/settings_repository.dart

import 'package:core/domain/entities/user_entity.dart';
import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart' as dartz;


abstract class SettingsRepository {
  Future<dartz.Either<Failure, UserEntity>> getStudentProfile();
}
