import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';
import 'package:core/network/dio_client.dart';
import 'package:core/constant.dart';
import 'package:teacher_app/core/local_data_source.dart';
import '../../models/assignment_model.dart';
import '../../../domain/entities/assignment.dart';

abstract class AssignmentRemoteDataSource {
  Future<Either<Failure, List<AssignmentModel>>> getAssignments({String? searchQuery, AssignmentStatus? filter});
}

class AssignmentRemoteDataSourceImpl implements AssignmentRemoteDataSource {
  final DioClient dioClient;
  final LocalDataSource localDataSource;

  AssignmentRemoteDataSourceImpl({required this.dioClient, required this.localDataSource});

  @override
  Future<Either<Failure, List<AssignmentModel>>> getAssignments({String? searchQuery, AssignmentStatus? filter}) async {
    try {
      final int? teacherId = await localDataSource.getUserId();
      if (teacherId == null) {
        return const Left(UnAuthenticated(message: 'الرجاء تسجيل الدخول مجدداً'));
      }

      final result = await dioClient.post(
        Constants.getAllAssignmentsEndpoint,
        data: {
          'teacher_id': teacherId,
        },
      );

      return result.fold(
        (failure) => Left(failure),
        (response) {
          final dynamic body = response.data;
          if (body is! Map<String, dynamic>) {
            return const Left(ValidationFailure(message: 'تنسيق الاستجابة غير صحيح'));
          }

          final int status = body['status'] is int ? body['status'] as int : 500;
          if (status != 200) {
            final String message = body['message']?.toString() ?? 'حدث خطأ في الخادم';
            return Left(ServerFailure(message: message, statusCode: status));
          }

          final dynamic data = body['data'];
          if (data is! List) {
            return const Left(ValidationFailure(message: 'تنسيق البيانات غير صحيح'));
          }

          List<AssignmentModel> items = data
              .map((e) => AssignmentModel.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList()
              .cast<AssignmentModel>();

          // تطبيق البحث والفلترة محلياً
          if (searchQuery != null && searchQuery.trim().isNotEmpty) {
            final String q = searchQuery.toLowerCase();
            items = items
                .where((a) => a.title.toLowerCase().contains(q) || a.subtitle.toLowerCase().contains(q))
                .toList();
          }
          if (filter != null && filter != AssignmentStatus.all) {
            items = items.where((a) => a.status == filter).toList();
          }

          return Right(items);
        },
      );
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}

// Assignment Remote Data Source Implementation:
// - Real Call: استخدام DioClient لاستدعاء الخادم وفق الاستجابة الموحدة
// - Error Handling: إعادة Either<Failure, T> برسائل عربية واضحة
// - No exceptions thrown upward
// - Search & Filter: مطبّقة محلياً بعد الجلب