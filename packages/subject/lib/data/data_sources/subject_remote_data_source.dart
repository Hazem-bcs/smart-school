import 'package:core/data/models/subject_model.dart';
import 'package:core/network/dio_client.dart';
import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:core/constant.dart';

abstract class SubjectRemoteDataSource {
  Future<Either<Failure, SubjectModel>> getSubject(int id);

  Future<Either<Failure, List<SubjectModel>>> getSubjectList(int id);
}

class SubjectRemoteDataSourceImpl implements SubjectRemoteDataSource {
  final DioClient dioClient;

  SubjectRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<Either<Failure, SubjectModel>> getSubject(int id) async {
    try {
      // RemoteDataSource: request subject details
      // Expects: { data: { subject_name, teacher_name, grade, classroom }, message, status }
      print('getSubject: $id');
      final responseEither = await dioClient.post(
        Constants.getSubjectEndpoint,
        data: {'subject_id': id},
      );
      return responseEither.fold(
        (failure) => Left(failure),
        (response) {
          try {
            // Log response at debug time
            // ignore: avoid_print
            print('SubjectRemoteDataSource.getSubject: status=${response.statusCode}, data=${response.data}');
            final Map<String, dynamic> data = response.data['data'] as Map<String, dynamic>;
            final model = SubjectModel.fromDetailJson(data, id: id);
            return Right(model);
          } catch (e) {
            try {
              final Map<String, dynamic> raw = response.data['data'] as Map<String, dynamic>;
              final model = SubjectModel.fromJson(raw);
              return Right(model);
            } catch (_) {
              return Left(UnknownFailure(message: 'تنسيق الاستجابة غير صالح'));
            }
          }
        },
      );
    } catch (e) {
      return Left(UnknownFailure(message: 'خطأ غير معروف: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<SubjectModel>>> getSubjectList(int id) async {
    try {
      // RemoteDataSource: request subject list for student
      // Expects: { data: [ { id, name, grade, classroom, teacher }, ... ], message, status }
      final responseEither = await dioClient.post(
        Constants.getSubjectListEndpoint,
        data: {'id': id},
      );
      return responseEither.fold(
        (failure) => Left(failure),
        (response) {
          try {
            // ignore: avoid_print
            print('SubjectRemoteDataSource.getSubjectList: status=${response.statusCode}, data_count=${(response.data['data'] as List?)?.length}');
            final List<dynamic> list = response.data['data'] as List<dynamic>;
            final models = list
                .whereType<Map<String, dynamic>>()
                .map((e) => SubjectModel.fromListJson(e))
                .toList();
            return Right(models);
          } catch (e) {
            return Left(UnknownFailure(message: 'تنسيق قائمة المواد غير صالح'));
          }
        },
      );
    } catch (e) {
      return Left(UnknownFailure(message: 'خطأ غير معروف: ${e.toString()}'));
    }
  }
}
