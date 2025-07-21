import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';
import '../entities/logout_entity.dart';

abstract class SettingsRepository {
  Future<Either<Failure, LogoutEntity>> logout(String userId);
}
