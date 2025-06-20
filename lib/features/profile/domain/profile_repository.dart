import 'package:dartz/dartz.dart';
import 'package:smart_school/core/network/failures.dart';
import 'package:smart_school/core/shared/domain/entites/user_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure,UserEntity>> getUserProfile();
}