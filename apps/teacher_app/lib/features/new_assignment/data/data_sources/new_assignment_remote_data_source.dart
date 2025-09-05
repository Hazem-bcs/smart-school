import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:core/network/dio_client.dart';
import 'package:core/network/failures.dart';
import '../models/new_assignment_model.dart';

abstract class NewAssignmentRemoteDataSource {
  Future<Either<Failure, Unit>> addNewAssignment(NewAssignmentModel assignment);
  Future<Either<Failure, List<String>>> getClasses(int teacherId);
}

class NewAssignmentRemoteDataSourceImpl implements NewAssignmentRemoteDataSource {
  final DioClient dioClient;

  NewAssignmentRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<Either<Failure, Unit>> addNewAssignment(NewAssignmentModel assignment) async {
    // ********************************************************
    // API وهمي إلى حين ربط الـ backend
    // استجابة موحدة: { data, message, status }
    // ********************************************************
    const String mockJson = '{"data": null, "message": "تم إنشاء الواجب بنجاح", "status": 200}';
    try {
      final Map<String, dynamic> decoded = jsonDecode(mockJson) as Map<String, dynamic>;
      final int status = decoded['status'] is int ? decoded['status'] as int : 500;
      if (status != 200) {
        final String message = decoded['message']?.toString() ?? 'حدث خطأ غير متوقع';
        return Left(ServerFailure(message: message, statusCode: status));
      }
      return const Right(unit);
    } catch (e) {
      return Left(UnknownFailure(message: 'حدث خطأ غير متوقع'));
    }

    /*
    // الكتلة الحقيقية (معلقة) لاستخدام DioClient
    final result = await dioClient.post('/assignments', data: assignment.toJson());
    return result.fold(
      (failure) => Left(failure),
      (response) {
        try {
          final dynamic body = response.data;
          final Map<String, dynamic> decoded = body is String ? jsonDecode(body) : Map<String, dynamic>.from(body as Map);
          final int status = decoded['status'] is int ? decoded['status'] as int : (response.statusCode ?? 500);
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
    */
  }

  @override
  Future<Either<Failure, List<String>>> getClasses(int teacherId) async {
    // ********************************************************
    // API وهمي إلى حين ربط الـ backend
    // استجابة موحدة: { data, message, status }
    // ********************************************************
    final String mockJson = '{"data": ["رياضيات - الشعبة 1", "رياضيات - الشعبة 2", "علوم - الشعبة 3"], "message": "تم الجلب بنجاح", "status": 200}';
    try {
      final Map<String, dynamic> decoded = jsonDecode(mockJson) as Map<String, dynamic>;
      final int status = decoded['status'] is int ? decoded['status'] as int : 500;
      if (status != 200) {
        final String message = decoded['message']?.toString() ?? 'فشل في جلب البيانات';
        return Left(ServerFailure(message: message, statusCode: status));
      }
      final List<dynamic> rawList = (decoded['data'] as List<dynamic>? ?? <dynamic>[]);
      final List<String> items = rawList.map((e) => e.toString()).toList();
      return Right(items);
    } catch (e) {
      return Left(UnknownFailure(message: 'حدث خطأ غير متوقع'));
    }

    /*
    // الكتلة الحقيقية (معلقة) لاستخدام DioClient
    final result = await dioClient.get('/teachers/$teacherId/classes');
    return result.fold(
      (failure) => Left(failure),
      (response) {
        try {
          final dynamic body = response.data;
          final Map<String, dynamic> decoded = body is String ? jsonDecode(body) : Map<String, dynamic>.from(body as Map);
          final int status = decoded['status'] is int ? decoded['status'] as int : (response.statusCode ?? 500);
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
    */
  }
} 