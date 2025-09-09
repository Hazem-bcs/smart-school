import 'dart:io';
import 'package:core/constant.dart';
import 'package:core/data/models/user_modle.dart';
import 'package:core/network/dio_client.dart';
import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;

abstract class ProfileRemoteDataSource {
  Future<Either<Failure, UserModel>> getProfileData(int studentId);
  Future<Either<Failure, UserModel>> updateProfileData({
    required int studentId,
    required String name,
    required String email,
    required String phone,
    required String address,
    File? imageFile,
  });
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

  @override
  Future<Either<Failure, UserModel>> updateProfileData({
    required int studentId,
    required String name,
    required String email,
    required String phone,
    required String address,
    File? imageFile,
  }) async {
    try {
      print('[ProfileRemoteDataSourceImpl] updateProfileData called');
      print('[ProfileRemoteDataSourceImpl] studentId=$studentId, name=$name, email=$email, phone=$phone, address=$address');
      if (imageFile != null) {
        final length = await imageFile.length();
        print('[ProfileRemoteDataSourceImpl] imageFile path=${imageFile.path}, size=${length} bytes');
      } else {
        print('[ProfileRemoteDataSourceImpl] imageFile is null, will upload without image');
      }
      final Map<String, dynamic> formMap = {
        'student_id': studentId,
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
      };

      if (imageFile != null) {
        formMap['image'] = await MultipartFile.fromFile(
          imageFile.path,
          filename: p.basename(imageFile.path),
        );
      }

      final formData = FormData.fromMap(formMap);

      print('[ProfileRemoteDataSourceImpl] Sending multipart/form-data to ${Constants.updateStudentProfileEndpoint}');
      final updateResponse = await dioClient.post(
        Constants.updateStudentProfileEndpoint,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      // If update succeeded at transport level, fetch the fresh profile regardless of body shape
      return updateResponse.fold(
        (failure) {
          print('[ProfileRemoteDataSourceImpl] Update request failed: ${failure.message}');
          return Left(failure);
        },
        (res) async {
          print('[ProfileRemoteDataSourceImpl] Update request success: status=${res.statusCode}, dataType=${res.data.runtimeType}');
          final fetchResponse = await dioClient.post(
            Constants.getStudentProfiel,
            data: {
              'id': studentId,
            },
          );

          return fetchResponse.fold(
            (failure) {
              print('[ProfileRemoteDataSourceImpl] Fetch profile after update failed: ${failure.message}');
              return Left(failure);
            },
            (res) {
              print('[ProfileRemoteDataSourceImpl] Fetch profile after update success: status=${res.statusCode}, dataType=${res.data.runtimeType}');
              try {
                if (res.data is List) {
                  final wrappedData = {'data': res.data};
                  final user = UserModel.fromLaravelResponse(wrappedData);
                  print('[ProfileRemoteDataSourceImpl] Parsed UserModel (List): id=${user.id}, name=${user.name}, photo=${user.profilePhotoUrl}');
                  return Right(user);
                }
                final user = UserModel.fromLaravelResponse(res.data);
                print('[ProfileRemoteDataSourceImpl] Parsed UserModel (Map): id=${user.id}, name=${user.name}, photo=${user.profilePhotoUrl}');
                return Right(user);
              } catch (e) {
                return Left(UnknownFailure(message: 'Invalid response format: ${e.toString()}'));
              }
            },
          );
        },
      );
    } catch (e) {
      return Left(ServerFailure(message: 'حدث خطأ غير متوقع: ${e.toString()}'));
    }
  }
}