import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:smart_school/core/network/failures.dart';

import '../../../../core/constant.dart';
import '../../../../core/network/dio_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/shared/data/models/user_modle.dart';


abstract class AuthRemoteDataSource {
  Future<Either<Failure, UserModel>> login(String email, String password);
  Future<Either<Failure, UserModel>> validateToken(String token);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<Either<Failure, UserModel>> login(String email, String password) async {
    try {
      final response = await dioClient.post(
        Constants.loginEndpoint,
        data: {'email': email, 'password': password},
      );
      return Right(UserModel.fromJson(response.data));
    } on DioException catch (e) {
      return Left(handleDioException(e));
    } catch (e) {
      return Left(UnknownFailure(message: 'Unknown error occurred'));
    }
  }

  @override
  Future<Either<Failure, UserModel>> validateToken(String token) async {
    try {
      final response = await dioClient.get(
        '/validate-token',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return Right(UserModel.fromJson(response.data));
    } on DioException catch (e) {
      return Left(handleDioException(e));
    } catch (e) {
      return Left(UnknownFailure(message: 'Unknown error occurred'));
    }
  }
}