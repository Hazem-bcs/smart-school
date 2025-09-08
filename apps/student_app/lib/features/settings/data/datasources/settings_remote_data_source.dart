// lib/features/settings/data/datasources/settings_remote_data_source.dart

import 'package:core/constant.dart';
import 'package:core/data/models/user_modle.dart';
import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:core/network/dio_client.dart';

abstract class SettingsRemoteDataSource {
  Future<Either<Failure, UserModel>> getStudentProfile(int studentId);
}

class SettingsRemoteDataSourceImpl implements SettingsRemoteDataSource {
  final DioClient dioClient;
  SettingsRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<Either<Failure, UserModel>> getStudentProfile(int studentId) async {
    try {
      print('getStudentProfile');
      final response = await dioClient.post(
        Constants.getStudentProfiel,
        data: {
          'id': studentId,
        },
      );

      return response.fold(
        (failure) => Left(failure),
        (res) {
          try {
            if (res.data is List) {
              return Left(UnknownFailure(
                  message:
                      'Invalid response format: expected Map<String, dynamic> but got List<dynamic>'));
            }
            final user = UserModel.fromLaravelResponse(res.data);
            return Right(user);
          } catch (e) {
            return Left(UnknownFailure(message: 'Invalid response format: ${e.toString()}'));
          }
        },
      );
    } catch (e) {
      print('getStudentProfile error: $e');
      return Left(ServerFailure(message: "حدث خطأ غير متوقع: ${e.toString()}"));
    }
  }
}