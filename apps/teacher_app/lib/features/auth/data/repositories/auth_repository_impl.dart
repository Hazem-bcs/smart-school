import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teacher_app/core/local_data_source.dart';
import 'package:teacher_app/features/auth/domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_remote_data_source.dart';


class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;
  final SharedPreferences prefs;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.prefs,
  });

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    final result = await remoteDataSource.login(email, password);
    return await result.fold(
      (failure) => Left(failure),
      (userModel) async {
        await localDataSource.saveId(int.parse(userModel.id));
        return Right(userModel.toEntity());
      },
    );
  }

  @override
  Future<Either<Failure, bool>> checkAuthStatus() async {
    final userId = await localDataSource.getUserId();
    if (userId == null) {
      return Left(UnAuthenticated(message: 'user is not logged in'));
    }
    return Right(true);
  }

  @override
  Future<Either<Failure, void>> logout() async {
    final userId = await localDataSource.getUserId();
    if (userId == null) {
      return Left(UnAuthenticated(message: 'user is not logged in'));
    }
    await remoteDataSource.logout(userId);
    await localDataSource.clearUserId();
    return Right(null);
  }
} 