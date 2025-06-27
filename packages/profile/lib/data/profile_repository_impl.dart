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