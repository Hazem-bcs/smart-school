import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';
import 'package:teacher_app/core/local_data_source.dart';
import '../../domain/entities/profile.dart';
import '../models/profile_model.dart';
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
  Future<Either<String, Profile>> updateProfile(Profile profile) async {
    try {
      final profileModel = ProfileModel(
        id: profile.id,
        name: profile.name,
        title: profile.title,
        subtitle: profile.subtitle,
        avatarUrl: profile.avatarUrl,
        contactInfo: profile.contactInfo.toModel(),
        socialMedia: profile.socialMedia.map((e) => e.toModel()).toList(),
        professionalInfo: profile.professionalInfo.toModel(),
      );
      
      final updatedProfile = await remoteDataSource.updateProfile(profileModel);
      return Right(updatedProfile as Profile);
    } catch (e) {
      return Left(e.toString());
    }
  }
} 