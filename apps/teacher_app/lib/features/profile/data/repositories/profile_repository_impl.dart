import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';
import 'package:teacher_app/core/local_data_source.dart';
import '../../domain/entities/profile.dart';
import '../data_sources/profile_remote_data_source.dart';
import '../../domain/repositories/profile_repository.dart';
import '../models/profile_model.dart';

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
      return const Left(UnAuthenticated(message: 'المستخدم غير مسجل الدخول'));
    }
    final result = await remoteDataSource.getProfile(userId);
    return result.map(_mapModelToEntity);
  }

  @override
  Future<Either<Failure, Profile>> updateProfile(Profile profile, {File? imageFile}) async {
    final model = _mapEntityToModel(profile);
    final userId = await localDataSource.getUserId();
    if (userId == null) {
      return const Left(UnAuthenticated(message: 'المستخدم غير مسجل الدخول'));
    }
    final result = await remoteDataSource.updateProfile(
      userId: userId,
      profileModel: model,
      imagePath: imageFile?.path,
    );
    return result.map(_mapModelToEntity);
  }

  // ================= Mapping =================
  Profile _mapModelToEntity(ProfileModel m) {
    return Profile(
      id: m.id,
      name: m.name,
      bio: m.bio,
      avatarUrl: m.avatarUrl,
      contactInfo: ContactInfo(email: m.contactInfoModel.email, phone: m.contactInfoModel.phone),
      socialMedia: m.socialMediaModel
          .map((s) => SocialMedia(platform: s.platform, url: s.url, icon: s.icon))
          .toList(),
      professionalInfo: ProfessionalInfo(
        subjectsTaught: m.professionalInfoModel.subjectsTaught,
        gradeLevels: m.professionalInfoModel.gradeLevels,
        department: m.professionalInfoModel.department,
        qualifications: m.professionalInfoModel.qualifications,
        certifications: m.professionalInfoModel.certifications,
      ),
    );
  }

  ProfileModel _mapEntityToModel(Profile e) {
    return ProfileModel(
      id: e.id,
      name: e.name,
      bio: e.bio,
      avatarUrl: e.avatarUrl,
      contactInfoModel: ContactInfoModel(email: e.contactInfo.email, phone: e.contactInfo.phone),
      socialMediaModel: e.socialMedia
          .map((s) => SocialMediaModel(platform: s.platform, url: s.url, icon: s.icon))
          .toList(),
      professionalInfoModel: ProfessionalInfoModel(
        subjectsTaught: e.professionalInfo.subjectsTaught,
        gradeLevels: e.professionalInfo.gradeLevels,
        department: e.professionalInfo.department,
        qualifications: e.professionalInfo.qualifications,
        certifications: e.professionalInfo.certifications,
      ),
    );
  }
} 