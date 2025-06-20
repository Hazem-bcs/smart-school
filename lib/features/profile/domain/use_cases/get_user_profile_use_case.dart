import 'package:dartz/dartz.dart';
import 'package:smart_school/core/network/failures.dart';
import 'package:smart_school/core/shared/domain/entites/user_entity.dart';
import 'package:smart_school/features/profile/domain/profile_repository.dart';

class GetUserProfileUseCase {
  final ProfileRepository repository;

  GetUserProfileUseCase(this.repository);

  Future<Either<Failure,UserEntity>> call() async {
    return await repository.getUserProfile();
  }
}
