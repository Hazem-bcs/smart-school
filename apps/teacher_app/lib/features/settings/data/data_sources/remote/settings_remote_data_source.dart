import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:core/network/dio_client.dart';
import 'package:core/network/failures.dart';
import '../../models/logout_model.dart';

abstract class SettingsRemoteDataSource {
  Future<Either<Failure, LogoutModel>> logout(String userId);
}

class SettingsRemoteDataSourceImpl implements SettingsRemoteDataSource {
  final DioClient dioClient;

  SettingsRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<Either<Failure, LogoutModel>> logout(String userId) async {
    // *****
    // هنا API وهمي (JSON ثابت) وفق الاستجابة الموحدة { data, message, status }
    // *****
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final String fakeJson = jsonEncode({
        'status': 200,
        'message': 'تم تسجيل الخروج بنجاح',
        'data': {
          'success': true,
          'user_id': userId,
        },
      });

      final Map<String, dynamic> decoded = jsonDecode(fakeJson) as Map<String, dynamic>;
      final int status = decoded['status'] is int ? decoded['status'] as int : 500;
      if (status != 200) {
        final String message = decoded['message']?.toString() ?? 'حدث خطأ غير متوقع';
        return Left(ServerFailure(message: message, statusCode: status));
      }

      final Map<String, dynamic> data = Map<String, dynamic>.from(decoded['data'] as Map);
      return Right(LogoutModel.fromWrappedJson(data, decoded['message']?.toString()));
    } catch (e) {
      return Left(UnknownFailure(message: 'حدث خطأ أثناء معالجة البيانات'));
    }

    // هنا كتلة DioClient الحقيقية (معلّقة) بنفس الشكل دائماً
    // try {
    //   final result = await dioClient.post(
    //     Constants.logoutEndpoint,
    //     data: {
    //       'user_id': userId,
    //     },
    //   );
    //   return result.fold(
    //     (failure) => Left(failure),
    //     (response) {
    //       try {
    //         final Map<String, dynamic> body = response.data is String
    //             ? jsonDecode(response.data as String)
    //             : Map<String, dynamic>.from(response.data as Map);
    //         final int status = body['status'] is int ? body['status'] as int : (response.statusCode ?? 500);
    //         if (status != 200) {
    //           final String message = body['message']?.toString() ?? 'حدث خطأ في الخادم';
    //           return Left(ServerFailure(message: message, statusCode: status));
    //         }
    //         final Map<String, dynamic> data = Map<String, dynamic>.from(body['data'] as Map);
    //         return Right(LogoutModel.fromWrappedJson(data, body['message']?.toString()));
    //       } catch (_) {
    //         return const Left(ValidationFailure(message: 'تنسيق الاستجابة غير صحيح'));
    //       }
    //     },
    //   );
    // } catch (e) {
    //   return Left(UnknownFailure(message: 'تعذر تنفيذ الطلب'));
    // }
  }
} 