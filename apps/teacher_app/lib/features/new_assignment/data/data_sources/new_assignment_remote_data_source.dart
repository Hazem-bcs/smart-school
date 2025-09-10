import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:core/network/dio_client.dart';
import 'package:core/network/failures.dart';
import 'package:core/constant.dart';
import 'package:teacher_app/core/local_data_source.dart';
import '../models/new_assignment_model.dart';

abstract class NewAssignmentRemoteDataSource {
  Future<Either<Failure, Unit>> addNewAssignment(NewAssignmentModel assignment);
  Future<Either<Failure, List<String>>> getClasses(int teacherId);
}

class NewAssignmentRemoteDataSourceImpl implements NewAssignmentRemoteDataSource {
  final DioClient dioClient;
  final LocalDataSource localDataSource;

  NewAssignmentRemoteDataSourceImpl({required this.dioClient, required this.localDataSource});

  @override
  Future<Either<Failure, Unit>> addNewAssignment(NewAssignmentModel assignment) async {
    try {
      final int? teacherId = await localDataSource.getUserId();
      if (teacherId == null) {
        return const Left(UnAuthenticated(message: 'الرجاء تسجيل الدخول مجدداً'));
      }

      print("assignment.classId: ${assignment.classId}");
      final Map<String, dynamic> payload = <String, dynamic>{
        'teacher_id': teacherId,
        'title': assignment.title,
        'description': assignment.description,
        'section_id': 34,
        'dueDate': assignment.dueDate.toIso8601String(),
      };

      final result = await dioClient.post(
        Constants.createAssignmentEndpoint,
        data: payload,
      );

      return result.fold(
        (failure) => Left(failure),
        (response) {
          try {
            final dynamic body = response.data;
            final Map<String, dynamic> decoded = body is String
                ? Map<String, dynamic>.from(jsonDecode(body) as Map)
                : Map<String, dynamic>.from(body as Map);

            final int status = decoded['status'] is int
                ? decoded['status'] as int
                : (response.statusCode ?? 500);
            if (status != 200) {
              final String message = decoded['message']?.toString() ?? 'حدث خطأ في إنشاء الواجب';
              return Left(ServerFailure(message: message, statusCode: status));
            }
            return const Right(unit);
          } catch (_) {
            return const Left(UnknownFailure(message: 'تنسيق الاستجابة غير متوقع'));
          }
        },
      );
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getClasses(int teacherId) async {
    try {
      final result = await dioClient.post(
        Constants.getAllClasses,
        data: {
          'teacher_id': teacherId,
        },
      );

      return result.fold(
        (failure) => Left(failure),
        (response) {
          try {
            final dynamic body = response.data;
            final Map<String, dynamic> decoded = body is String
                ? Map<String, dynamic>.from(jsonDecode(body) as Map)
                : Map<String, dynamic>.from(body as Map);
            final int status = decoded['status'] is int
                ? decoded['status'] as int
                : (response.statusCode ?? 500);
            if (status != 200) {
              final String message = decoded['message']?.toString() ?? 'فشل في جلب البيانات';
              return Left(ServerFailure(message: message, statusCode: status));
            }
            final List<dynamic> raw = (decoded['data'] as List<dynamic>? ?? <dynamic>[]);
            return Right(raw.map((e) => e.toString()).toList());
          } catch (_) {
            return const Left(UnknownFailure(message: 'تنسيق الاستجابة غير متوقع'));
          }
        },
      );
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
} 