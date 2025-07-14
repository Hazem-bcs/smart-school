import 'package:dartz/dartz.dart';
import '../entities/profile.dart';

abstract class ProfileRepository {
  Future<Either<String, Profile>> getProfile();
  Future<Either<String, Profile>> updateProfile(Profile profile);
} 