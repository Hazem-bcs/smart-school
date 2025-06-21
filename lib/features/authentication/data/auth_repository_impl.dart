import 'package:dartz/dartz.dart';

import '../../../../core/network/failures.dart';
import '../../../core/network/network_info.dart';
import '../../../core/shared/domain/entites/user_entity.dart';
import '../domain/auth_repository.dart';
import 'data_sources/auth_local_data_source.dart';
import 'data_sources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    final result = await remoteDataSource.login(email, password);
    return result.fold(
          (failure) => left(failure),
          (userModel) {
        if (userModel.id != null) {
          localDataSource.cacheId(userModel.id!);
        }
        return Right(userModel.toEntity());
      },
    );
  }

  @override
  Future<Either<Failure, bool>> checkAuthStatus() async {
    if (await networkInfo.isConnected) {
      final studentId = await localDataSource.getId();
       if (studentId != null )
           {return left(CacheFailure(message: 'the user un authenticated'));}
      else {
           // await localDataSource.cacheId(userModel.id!);
           return Right(true);
           }
    } else {
      return Left(ConnectionFailure(message: ''));
    }
  }

  @override
  Future<bool> hasSeenOnboarding() async {
    return await localDataSource.hasSeenOnboarding();
  }

  @override
  Future<void> cacheOnboardingStatus() async {
    await localDataSource.cacheOnboardingStatus();
  }
}
