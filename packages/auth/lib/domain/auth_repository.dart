import 'package:core/domain/entities/user_entity.dart';
import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';



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