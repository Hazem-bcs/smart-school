import 'package:core/data/models/user_modle.dart';
import 'package:core/network/dio_client.dart';
import 'package:core/network/failures.dart';
import 'package:core/constant.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRemoteDataSource {
  Future<Either<Failure, UserModel>> login(String email, String password);
  Future<Either<Failure, void>> logout(int? userId);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<Either<Failure, UserModel>> login(String email, String password) async {
    try {
      final response = await dioClient.post(
        Constants.loginEndpoint,
        data: {
          'email': email, 
          'password': password,
          'role': 2, // 2 = Student role
        },
      );
      
      return response.fold(
        (failure) => Left(failure),
        (response) {
          try {
            final user = UserModel.fromLaravelResponse(response.data);
            return Right(user);
          } catch (e) {
            return Left(UnknownFailure(message: 'Invalid response format: ${e.toString()}'));
          }
        },
      );
    } catch (e) {
      return Left(UnknownFailure(message: 'Unknown error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> logout(int? userId) async {
    try {
      final response = await dioClient.post(
        '/api/logout',
        data: {
          'role': 2, // 2 = Student role
          'id': userId,
        },
      );
      
      return response.fold(
        (failure) {
          print(failure);
          print('hi');
          return Left(failure);
        },
        (response) {
          print(response);
          // إذا وصلنا هنا، يعني أن الطلب نجح
          return const Right(null);
        },
      );
    } catch (e) {
      return Left(UnknownFailure(message: 'Unknown error occurred during logout: ${e.toString()}'));
    }
  }
}