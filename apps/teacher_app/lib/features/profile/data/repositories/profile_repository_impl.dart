import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';
import 'package:teacher_app/core/local_data_source.dart';
import '../../domain/entities/profile.dart';
import '../data_sources/profile_remote_data_source.dart';
import '../../domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, Profile>> getProfile() async {
    final userId = await localDataSource.getUserId();
    if (userId == null) {
      return Left(UnAuthenticated(message: 'user is not logged in'));
    }
    final result = await remoteDataSource.getProfile(userId);
    return result.fold(
      (failure) => Left(failure),
      (profileModel) => Right(profileModel.toEntity()),
    );
  }

  @override
  Future<Either<Failure, Profile>> updateProfile(Profile profile) async {
    final result = await remoteDataSource.updateProfile(profile.toModel());
    return result.fold(
      (failure) => Left(failure),
      (profileModel) => Right(profileModel.toEntity()),
    );
  }
} 