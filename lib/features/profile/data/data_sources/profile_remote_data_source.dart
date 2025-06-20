import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:smart_school/core/network/failures.dart';

import '../../../../core/constant.dart';
import '../../../../core/network/dio_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/shared/data/models/user_modle.dart';


abstract class ProfileRemoteDataSource {
  Future<Either<Failure, UserModel>> getProfileData(int studentId);

}

class AuthRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<Either<Failure, UserModel>> getProfileData(int studentId) async {
    try {
      final response = await dioClient.post(
        Constants.getProfileData,
        data: {'student_id': studentId},
      );
      return Right(UserModel.fromJson(response.data));
    } on DioException catch (e) {
      return Left(handleDioException(e));
    } catch (e) {
      return Left(UnknownFailure(message: 'Unknown error occurred'));
    }
  }
}