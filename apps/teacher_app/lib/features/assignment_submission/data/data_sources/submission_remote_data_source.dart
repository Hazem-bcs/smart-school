import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';
import 'package:core/network/dio_client.dart';
import 'package:core/constant.dart';
import '../models/student_submission_model.dart';

abstract class SubmissionRemoteDataSource {
  Future<Either<Failure, List<StudentSubmissionModel>>> getStudentSubmissions(String assignmentId);
  Future<Either<Failure, bool>> submitGrade(String submissionId, String grade, String feedback);
  Future<Either<Failure, bool>> markAssignmentAsGraded(String assignmentId);
}

class SubmissionRemoteDataSourceImpl implements SubmissionRemoteDataSource {
  final DioClient dioClient;

  SubmissionRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<Either<Failure, List<StudentSubmissionModel>>> getStudentSubmissions(String assignmentId) async {
    try {
      final result = await dioClient.post(
        Constants.getSubmitAssignmentByIdEndpoint,
        data: {
          'assignment_id': assignmentId,
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
              final String message = decoded['message']?.toString() ?? 'حدث خطأ غير متوقع';
              return Left(ServerFailure(message: message, statusCode: status));
            }

            final List<dynamic> data = List<dynamic>.from(decoded['data'] as List<dynamic>);
            final List<StudentSubmissionModel> items = data
                .map((e) => StudentSubmissionModel.fromJson(Map<String, dynamic>.from(e as Map)))
                .toList();
            return Right(items);
          } catch (_) {
            return const Left(UnknownFailure(message: 'خطأ في تحليل البيانات'));
          }
        },
      );
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> submitGrade(String submissionId, String grade, String feedback) async {
    try {
      final result = await dioClient.post(
        Constants.gradeAssignmentByIdEndpoint,
        data: {
          'submission_id': submissionId,
          'grade': grade,
          'feedback': feedback,
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
              final String message = decoded['message']?.toString() ?? 'فشل حفظ التقييم';
              return Left(ServerFailure(message: message, statusCode: status));
            }
            // يمكن استخدام decoded['data'] إن لزم (قيمته متوقعة true)
            return const Right(true);
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
  Future<Either<Failure, bool>> markAssignmentAsGraded(String assignmentId) async {
    try {
      final result = await dioClient.post(
        Constants.markAssignmentAsGradedEndpoint,
        data: {
          'assignment_id': assignmentId,
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
              final String message = decoded['message']?.toString() ?? 'فشل تنفيذ العملية';
              return Left(ServerFailure(message: message, statusCode: status));
            }
            // التوقع: { data: true, message: ..., status: 200 }
            return const Right(true);
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