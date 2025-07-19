import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';
import '../entities/profile.dart';

abstract class ProfileRepository {
Future<Either<Failure, Profile>> getProfile();
  Future<Either<String, Profile>> updateProfile(Profile profile);
} 