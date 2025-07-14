import 'package:dartz/dartz.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/entities/profile.dart';
import '../data_sources/profile_remote_data_source.dart';
import '../data_sources/profile_local_data_source.dart';
import '../data_sources/profile_mock_data_source.dart';
import '../models/profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final ProfileLocalDataSource localDataSource;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<String, Profile>> getProfile() async {
    try {
      // For demo purposes, return mock data
      final mockProfile = ProfileMockDataSource.getMockProfile();
      // Save to local cache
      await localDataSource.saveProfile(mockProfile);
      return Right(mockProfile as Profile);
    } catch (e) {
      // If mock fails, try local cache
      try {
        final localProfile = await localDataSource.getProfile();
        if (localProfile != null) {
          return Right(localProfile as Profile);
        }
      } catch (localError) {
        // Both mock and local failed
      }
      return Left(e.toString());
    }
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
        contactInfo: profile.contactInfo,
        socialMedia: profile.socialMedia,
        professionalInfo: profile.professionalInfo,
      );
      
      final updatedProfile = await remoteDataSource.updateProfile(profileModel);
      // Update local cache
      await localDataSource.saveProfile(updatedProfile);
      return Right(updatedProfile as Profile);
    } catch (e) {
      return Left(e.toString());
    }
  }
} 