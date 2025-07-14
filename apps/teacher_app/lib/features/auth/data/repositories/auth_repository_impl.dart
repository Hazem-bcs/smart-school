import 'package:dartz/dartz.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/auth_response.dart';
import '../data_sources/auth_remote_data_source.dart';
import '../data_sources/auth_local_data_source.dart';
import '../models/user_model.dart';
import '../models/auth_response_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<String, AuthResponse>> login(String email, String password) async {
    try {
      final response = await remoteDataSource.login(email, password);
      final authResponse = AuthResponseModel.fromJson(response);
      
      // Save token and user data locally
      await localDataSource.saveToken(authResponse.token);
      await localDataSource.saveUserData(authResponse.user.toJson());
      
      return Right(authResponse.toEntity());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, User>> checkAuthStatus() async {
    try {
      final token = await localDataSource.getToken();
      if (token == null) {
        return Left('No token found');
      }

      final response = await remoteDataSource.checkAuthStatus(token);
      final user = UserModel.fromJson(response['user'] as Map<String, dynamic>);
      
      return Right(user.toEntity());
    } catch (e) {
      // Clear invalid token
      await localDataSource.clearToken();
      await localDataSource.clearUserData();
      return Left(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      final token = await localDataSource.getToken();
      if (token != null) {
        await remoteDataSource.logout(token);
      }
    } catch (e) {
      // Continue with local cleanup even if remote logout fails
      print('Remote logout failed: $e');
    } finally {
      // Always clear local data
      await localDataSource.clearToken();
      await localDataSource.clearUserData();
    }
  }

  @override
  Future<String?> getStoredToken() async {
    return await localDataSource.getToken();
  }

  @override
  Future<User?> getStoredUser() async {
    final userData = await localDataSource.getUserData();
    if (userData != null) {
      return UserModel.fromJson(userData).toEntity();
    }
    return null;
  }
} 