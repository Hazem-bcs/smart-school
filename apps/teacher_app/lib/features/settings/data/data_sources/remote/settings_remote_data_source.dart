import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:core/network/dio_client.dart';
import 'package:core/network/failures.dart';
import 'package:core/constant.dart';
import '../../models/logout_model.dart';

abstract class SettingsRemoteDataSource {
  Future<Either<Failure, LogoutModel>> logout(String userId);
}

class SettingsRemoteDataSourceImpl implements SettingsRemoteDataSource {
  final DioClient dioClient;

  SettingsRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<Either<Failure, LogoutModel>> logout(String userId) async {
    try {
      final result = await dioClient.post(
        Constants.logoutEndpoint,
        data: {
          'id': userId,
          'role': 3,
        },
      );
      return result.fold(
        (failure) => Left(failure),
        (response) {
          try {
            final Map<String, dynamic> body = response.data is String
                ? jsonDecode(response.data as String)
                : Map<String, dynamic>.from(response.data);
            final int status = body['status'] is int ? body['status'] as int : (response.statusCode ?? 500);
            if (status != 200) {
              final String message = body['message']?.toString() ?? 'حدث خطأ في الخادم';
              return Left(ServerFailure(message: message, statusCode: status));
            }
            // Some backends may return data=null on logout; handle both
            final dynamic rawData = body['data'];
            if (rawData is Map) {
              final Map<String, dynamic> data = Map<String, dynamic>.from(rawData);
              return Right(LogoutModel.fromWrappedJson(data, body['message']?.toString()));
            } else {
              return Right(LogoutModel(
                success: true,
                message: body['message']?.toString(),
                userId: userId,
              ));
            }
          } catch (_) {
            return const Left(ValidationFailure(message: 'تنسيق الاستجابة غير صحيح'));
          }
        },
      );
    } catch (e) {
      return Left(UnknownFailure(message: 'تعذر تنفيذ الطلب'));
    }
  }
} 