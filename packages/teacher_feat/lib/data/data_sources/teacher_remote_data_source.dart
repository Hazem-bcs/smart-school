import 'package:core/constant.dart';
import 'package:core/network/dio_client.dart';
import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';

import '../models/teatcher_model.dart';

abstract class TeacherRemoteDataSource {
  Future<Either<Failure, List<TeacherModel>>> getTeacherList(int studentId);

  Future<Either<Failure, TeacherModel>> getTeacherById(int teacherId);
}

class TeacherRemoteDataSourceImpl extends TeacherRemoteDataSource {
  final DioClient dioClient;

  TeacherRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<Either<Failure, TeacherModel>> getTeacherById(int teacherId) async {
    // ignore: avoid_print
    print("TeacherRemoteDataSource.getTeacherById -> id=$teacherId");
    try {
      final responseEither = await dioClient.post(
        Constants.getTeacherById,
        data: {'id': teacherId},
      );
      return responseEither.fold(
        (failure) => Left(failure),
        (response) {
          try {
            // ignore: avoid_print
            print('TeacherRemoteDataSource.getTeacherById: status=${response.statusCode}, data=${response.data}');
            final Map<String, dynamic> data =
                (response.data is Map<String, dynamic> && response.data['data'] is Map<String, dynamic>)
                    ? response.data['data']
                    : response.data as Map<String, dynamic>;
            final teacher = TeacherModel.fromJson(data);
            return Right(teacher);
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
  Future<Either<Failure, List<TeacherModel>>> getTeacherList(
    int studentId,
  ) async {
    // ignore: avoid_print
    print("TeacherRemoteDataSource.getTeacherList -> studentId=$studentId");
    try {
      final responseEither = await dioClient.post(
        Constants.getTeacherList,
        data: {'student_id': studentId},
      );
      // ignore: avoid_print
      print('TeacherRemoteDataSource.getTeacherList: responseEither=$responseEither');
      return responseEither.fold(
        (failure) => Left(failure),
        (response) {
          try {
            // ignore: avoid_print
            print('TeacherRemoteDataSource.getTeacherList: status=${response.statusCode}, data_len=${(response.data['data'] as List?)?.length}');
            final List<dynamic> teachersData = response.data['data'] as List<dynamic>;
            final teachers = teachersData
                .map((teacherJson) => TeacherModel.fromJson(teacherJson))
                .toList();
            // ignore: avoid_print
            print('TeacherRemoteDataSource.getTeacherList: parsed=${teachers.length}');
            
            return Right(teachers);
          } catch (e) {
            return Left(UnknownFailure(message: 'Invalid response format: ${e.toString()}'));
          }
        },
      );
    } catch (e) {
      return Left(UnknownFailure(message: 'Unknown error occurred: ${e.toString()}'));
    }
  }
}