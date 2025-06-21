import 'package:dartz/dartz.dart';
import 'package:smart_school/core/network/network_info.dart';
import 'package:smart_school/features/profile/data/data_sources/profile_local_data_source.dart';
import 'package:smart_school/features/profile/data/data_sources/profile_remote_data_source.dart';
import 'package:smart_school/features/profile/domain/profile_repository.dart';

import '../../../core/network/failures.dart';
import '../../../core/shared/domain/entites/user_entity.dart';

class ProfileRepositoryImpl extends ProfileRepository {

  final ProfileLocalDataSource localDataSource;
  final ProfileRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ProfileRepositoryImpl({required this.remoteDataSource,required this.localDataSource,required this.networkInfo});

  @override
  Future<Either<Failure, UserEntity>> getUserProfile() async {
   if (await networkInfo.isConnected) {
     final studentId = await localDataSource.getId();
     final result = await remoteDataSource.getProfileData(studentId ?? 0);
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