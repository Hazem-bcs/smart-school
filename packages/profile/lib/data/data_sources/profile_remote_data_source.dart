import 'package:core/constant.dart';
import 'package:core/data/models/user_modle.dart';
import 'package:core/network/dio_client.dart';
import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';

abstract class ProfileRemoteDataSource {
  Future<Either<Failure, UserModel>> getProfileData(int studentId);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final DioClient dioClient;

  ProfileRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<Either<Failure, UserModel>> getProfileData(int studentId) async {
    print('[ProfileRemoteDataSourceImpl] getProfileData called with studentId: $studentId');
    try {
      final response = await dioClient.post(
        Constants.getStudentProfiel,
        data: {
          'id': studentId,
        },
      );
      print('[ProfileRemoteDataSourceImpl] dioClient.post response: $response');

      return response.fold(
        (failure) {
          print('[ProfileRemoteDataSourceImpl] Failure from dioClient.post: $failure');
          return Left(failure);
        },
        (res) {
          try {
            print('[ProfileRemoteDataSourceImpl] Raw response data: ${res.data}');
            if (res.data is List) {
              print('[ProfileRemoteDataSourceImpl] Response is a List, processing first item');
              // Handle List response by wrapping it in a Map with 'data' key
              final wrappedData = {'data': res.data};
              final user = UserModel.fromLaravelResponse(wrappedData);
              print('[ProfileRemoteDataSourceImpl] Parsed UserModel: $user');
              return Right(user);
            }
            final user = UserModel.fromLaravelResponse(res.data);
            print('[ProfileRemoteDataSourceImpl] Parsed UserModel: $user');
            return Right(user);
          } catch (e) {
            print('[ProfileRemoteDataSourceImpl] Exception during parsing: $e');
            return Left(UnknownFailure(message: 'Invalid response format: ${e.toString()}'));
          }
        },
      );
    } catch (e) {
      print('[ProfileRemoteDataSourceImpl] Exception in getProfileData: $e');
      return Left(ServerFailure(message: "حدث خطأ غير متوقع: ${e.toString()}"));
    }
  }
}