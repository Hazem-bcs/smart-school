import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';
import '../entities/profile.dart';

abstract class ProfileRepository {
  Future<Either<Failure, Profile>> getProfile();
  Future<Either<Failure, Profile>> updateProfile(Profile profile);
} 