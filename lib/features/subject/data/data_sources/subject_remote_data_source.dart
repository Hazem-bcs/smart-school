import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:smart_school/core/network/failures.dart';

import '../../../../core/constant.dart';
import '../../../../core/network/dio_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../models/subject_model.dart';


abstract class SubjectRemoteDataSource {
  Future<Either<Failure, SubjectModel>> getSubject(int id);

}

class SubjectRemoteDataSourceImpl implements SubjectRemoteDataSource {
  final DioClient dioClient;

  SubjectRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<Either<Failure, SubjectModel>> getSubject(int id) async {
    // try {
    //   final response = await dioClient.post(
    //     Constants.getSubjectListEndpoint,
    //     data: {'id': id},
    //   );
    //   return Right(SubjectModel.fromJson(response.data));
    // } on DioException catch (e) {
    //   return Left(handleDioException(e));
    // } catch (e) {
    //   return Left(UnknownFailure(message: 'Unknown error occurred'));
    // }
    return Right(SubjectModel(id: 1, name: 'رياضيات', image: 'https://cbx-prod.b-cdn.net/COLOURBOX60175808.jpg?width=800&height=800&quality=70'));
  }

}