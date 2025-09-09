import 'dart:io';
import 'package:core/domain/entities/user_entity.dart';
import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';

import '../profile_repository.dart';

class GetUserProfileUseCase {
  final ProfileRepository repository;

  GetUserProfileUseCase(this.repository);

  Future<Either<Failure,UserEntity>> call() async {
    return await repository.getUserProfile();
  }
}

class UpdateUserProfileUseCase {
  final ProfileRepository repository;

  UpdateUserProfileUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call({
    required String name,
    required String email,
    required String phone,
    required String address,
    File? imageFile,
  }) async {
    return await repository.updateUserProfile(
      name: name,
      email: email,
      phone: phone,
      address: address,
      imageFile: imageFile,
    );
  }
}