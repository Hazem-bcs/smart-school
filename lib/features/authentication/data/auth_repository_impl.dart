import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:smart_school/core/network/dio_exception.dart';

import '../../../../core/network/failures.dart';
import '../../../core/network/network_info.dart';
import '../domain/auth_repository.dart';
import '../domain/entites/user_entity.dart';
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
        if (userModel.token != null) {
          localDataSource.cacheToken(userModel.token!);
        }
        return Right(userModel.toEntity());
      },
    );
  }

  @override
  Future<Either<Failure, UserEntity>> checkAuthStatus() async {
    if (await networkInfo.isConnected) {
      final token = await localDataSource.getToken();
      final result = await remoteDataSource.validateToken(token ?? '');
      return result.fold(
      (failure) => left(failure),
      (userModel) async {
        await localDataSource.cacheToken(userModel.token!);
        return Right(userModel.toEntity());
      }
      );
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
