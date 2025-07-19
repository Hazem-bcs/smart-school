import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';
import '../repositories/profile_repository.dart';
import '../entities/profile.dart';

class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<Either<Failure, Profile>> call(Profile profile) async {
    return await repository.updateProfile(profile);
  }
} 