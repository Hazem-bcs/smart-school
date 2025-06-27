import 'package:core/constant.dart';
import 'package:core/data/models/user_modle.dart';
import 'package:core/network/dio_client.dart';
import 'package:core/network/dio_exception.dart';
import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';


abstract class AuthRemoteDataSource {
  Future<Either<Failure, UserModel>> login(String email, String password);
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
}