import 'package:dartz/dartz.dart';
import 'package:smart_school/core/network/network_info.dart';
import 'package:smart_school/features/profile/data/data_sources/profile_local_data_source.dart';
import 'package:smart_school/features/profile/data/data_sources/profile_remote_data_source.dart';
import 'package:smart_school/features/profile/domain/profile_repository.dart';

import '../../../core/network/failures.dart';
import '../../../core/shared/domain/entites/user_entity.dart';

class ProfileRepositoryImpl extends ProfileRepository {

  final ProfileLocalDataSource profileLocalDataSource;
  final ProfileRemoteDataSource profileRemoteDataSource;
  final NetworkInfo networkInfo;

  ProfileRepositoryImpl({required this.profileRemoteDataSource,required this.profileLocalDataSource,required this.networkInfo});

  @override
  Future<Either<Failure, UserEntity>> getUserProfile() async {
   if (await networkInfo.isConnected) {
     final studentId = await profileLocalDataSource.getId();
     final result = await profileRemoteDataSource.getProfileData(studentId ?? 0);
     return result.fold(
           (failure) => Left(failure),
           (userModel) => Right(userModel.toEntity()),
     );
   }
   else {
     return Left(ConnectionFailure(message: 'ConnectionFailure'));
   }

  }
}