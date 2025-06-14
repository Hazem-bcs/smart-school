import 'package:dartz/dartz.dart';
import 'package:smart_school/features/authentication/data/models/user_modle.dart';

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
    try {
      final userModel = await remoteDataSource.login(email, password);

      // تخزين الـ token محلياً عند الحصول عليه
      if (userModel.token != null) {
        await localDataSource.cacheToken(userModel.token!);
      }

      return Right(userModel.toEntity());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> checkAuthStatus() async {
    if (await networkInfo.isConnected) {
      try {
        final token = await localDataSource.getToken();
        final userModel = await remoteDataSource.validateToken(token ?? '');
        // final userModel = UserModel(email: 'admin123@gmail.com', password: '12345678',name: 'admin',token: 'sdadasdnkadwkasjxklajldjaskldjlkadjalksjdlkasjdlkajdlkajdlkasjdaslkdjaksljd');
        await localDataSource.cacheToken(userModel.token!);
        return Right(userModel.toEntity()); // أعد بيانات المستخدم
      }  on Failure catch (e) {
        return Left(e);
      } catch (e) {
        return Left(UnknownFailure(message: e.toString()));
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