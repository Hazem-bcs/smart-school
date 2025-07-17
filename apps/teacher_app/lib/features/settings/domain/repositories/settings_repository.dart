// lib/features/settings/domain/repositories/settings_repository.dart

import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart' as dartz; // احتفظ بالاسم المستعار!

import '../entities/logout_status_entity.dart';
// بافتراض أن لديك هذا الكيان

abstract class SettingsRepository {
  // هذا هو تعريف دالة مجردة. ليس لها جسم.
  Future<dartz.Either<Failure, LogoutStatusEntity>> logout();
}
