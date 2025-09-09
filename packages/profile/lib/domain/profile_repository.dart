import 'dart:io';
import 'package:core/domain/entities/user_entity.dart';
import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';

abstract class ProfileRepository {
  Future<Either<Failure,UserEntity>> getUserProfile();
  Future<Either<Failure,UserEntity>> updateUserProfile({
    required String name,
    required String email,
    required String phone,
    required String address,
    File? imageFile,
  });
}