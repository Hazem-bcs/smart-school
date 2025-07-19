import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:teacher_app/features/profile/domain/entities/profile.dart';

import '../repositories/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  Future<Either<Failure, Profile>> call() async {
    return await repository.getProfile();
  }
} 