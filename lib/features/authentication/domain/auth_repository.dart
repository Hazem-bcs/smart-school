import 'package:dartz/dartz.dart';


import '../../../core/network/failures.dart';
import '../../../core/shared/domain/entites/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, bool>> checkAuthStatus();

  Future<bool> hasSeenOnboarding();
  Future<void> cacheOnboardingStatus ();


// Future<Either<Failure, UserEntity>> updateProfile({required UserEntity user, String? imagePath});
// Future<Either<Failure, void>> changePassword({required String currentPassword, required String newPassword});
// Future<Either<Failure, void>> logout();
}