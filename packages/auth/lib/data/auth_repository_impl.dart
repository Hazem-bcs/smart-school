import 'package:core/domain/entities/user_entity.dart';
import 'package:core/network/failures.dart';
import 'package:core/network/network_info.dart';
import 'package:dartz/dartz.dart';

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
    return result.fold((failure) => left(failure), (userModel) {
      if (userModel.id != null) {
        localDataSource.cacheId(userModel.id!);
      }
      return Right(userModel.toEntity());
    });
  }

  @override
  Future<Either<Failure, bool>> checkAuthStatus() async {
    if (await networkInfo.isConnected) {
      final userId = await localDataSource.getId();
      if (userId == null) {
        return left(CacheFailure(message: 'the user un authenticated'));
      } else {
        // await localDataSource.cacheId(userModel.id!);
        return Right(true);
      }
    } else {
      return Left(ConnectionFailure(message: ''));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    final userId = await localDataSource.getId();
    try {
      // محاولة تسجيل الخروج من السيرفر
      final remoteResult = await remoteDataSource.logout(userId);

      // مسح البيانات المحلية بغض النظر عن نتيجة السيرفر
      await localDataSource.clearId();

      return remoteResult.fold(
        (failure) => Left(failure),
        (_) => const Right(null),
      );
    } catch (e) {
      // في حالة حدوث خطأ، نمسح البيانات المحلية على أي حال
      await localDataSource.clearId();
      return Left(UnknownFailure(message: 'Logout failed: ${e.toString()}'));
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
