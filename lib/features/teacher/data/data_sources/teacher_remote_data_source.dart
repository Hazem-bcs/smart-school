import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../../core/constant.dart';
import '../../../../../core/network/dio_exception.dart';
import '../../../../../core/network/failures.dart';
import '../models/teatcher_model.dart';

abstract class TeacherRemoteDataSource {
  Future<Either<Failure,List<TeacherModel>>> getTeacherList(int studentId);

  Future<Either<Failure,TeacherModel>> getTeacherById(int teacherId);
}

class TeacherRemoteDataSourceImpl extends TeacherRemoteDataSource {
  final Dio dioClient;

  TeacherRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<Either<Failure, TeacherModel>> getTeacherById(int teacherId) async {
    try {
      final response = await dioClient.post(
        Constants.getTeacherById,
        data: {'id': teacherId},
      );
      return Right(TeacherModel.fromJson(response.data));
    } on DioException catch (e) {
      return Left(handleDioException(e));
    } catch (e) {
      return Left(UnknownFailure(message: 'Unknown error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<TeacherModel>>> getTeacherList(int studentId) async {
    // try {
    //   final response = await dioClient.post(
    //     Constants.getTeacherList,
    //     data: {'id': studentId},
    //   );
    //   return Right(TeacherModel.fromJson(response.data));
    // } on DioException catch (e) {
    //   return Left(handleDioException(e));
    // } catch (e) {
    //   return Left(UnknownFailure(message: 'Unknown error occurred'));
    // }

    print("Fetching data from API...");
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    final List<Map<String, dynamic>> dummyJson = [
      {
        "id": "1", "name": "Rama", "image": "https://safasfasf",
        "description":'مدرسة مواد عدة لديها مهارات جيدة',
        "subjects": "['id' : '3','name' : 'علوم' , 'image': 'null']",
      },
      {
        "id": "2", "name": "ahmad", "image": "https://safasfasf",
        "description":'مدرس مواد عدة لديه مهارات جيدة',
        "subjects": "['id' : '1','name' : 'رياضيات' , 'image': 'null']",
      },
      {
        "id": "3", "name": "mazen", "image": "https://safasfasf",
        "description":'مدرس مواد عدة لديه مهارات جيدة',
        "subjects": "[ ['id' : '1','name' : 'رياضيات' , 'image': 'null'], ['id' : '2','name' : 'عربي' , 'image': 'null']]",
      }
    ];
    return Right(dummyJson.map((json) => TeacherModel.fromJson(json)).toList());
  }
}