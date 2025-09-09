import 'dart:io';
import 'package:core/domain/entities/user_entity.dart';
import 'package:core/network/failures.dart';
import 'package:core/network/network_info.dart';
import 'package:dartz/dartz.dart';

import '../domain/profile_repository.dart';
import 'data_sources/profile_local_data_source.dart';
import 'data_sources/profile_remote_data_source.dart';


class ProfileRepositoryImpl extends ProfileRepository {

  final ProfileLocalDataSource localDataSource;
  final ProfileRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ProfileRepositoryImpl({required this.remoteDataSource,required this.localDataSource,required this.networkInfo});

  @override
  Future<Either<Failure, UserEntity>> getUserProfile() async {
   final studentId = await localDataSource.getId();
     final result = await remoteDataSource.getProfileData(studentId ?? 0);
     return result.fold(
           (failure) => Left(failure),
           (userModel) => Right(userModel.toEntity()),
     );

  }

  @override
  Future<Either<Failure, UserEntity>> updateUserProfile({
    required String name,
    required String email,
    required String phone,
    required String address,
    File? imageFile,
  }) async {
    final studentId = await localDataSource.getId();
    if (studentId == null) {
      return const Left(UnAuthenticated(message: 'المستخدم غير مسجل الدخول'));
    }
    final result = await remoteDataSource.updateProfileData(
      studentId: studentId,
      name: name,
      email: email,
      phone: phone,
      address: address,
      imageFile: imageFile,
    );
    return result.fold(
      (failure) => Left(failure),
      (userModel) => Right(userModel.toEntity()),
    );
  }
}