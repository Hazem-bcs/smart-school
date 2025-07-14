import 'package:dartz/dartz.dart';
import '../repositories/profile_repository.dart';
import '../entities/profile.dart';

class GetProfileUseCase {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  Future<Either<String, Profile>> call() async {
    return await repository.getProfile();
  }
} 