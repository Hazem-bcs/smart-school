import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';
import 'package:core/network/dio_client.dart';
import 'package:teacher_app/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<Either<Failure, UserModel>> login(String email, String password);
  Future<Either<Failure, UserModel>> checkAuthStatus(int userId);
  Future<Either<Failure, void>> logout(int userId);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<Either<Failure, UserModel>> login(String email, String password) async {
    // *****
    // هنا API وهمي (JSON ثابت) وفق الاستجابة الموحدة { data, message, status }
    // *****
    await Future.delayed(const Duration(milliseconds: 800));
    try {
      final String fakeJson = jsonEncode({
        'status': 200,
        'message': 'تم تسجيل الدخول بنجاح',
        'data': {
          'id': '1',
          'name': 'معلم تجريبي',
          'email': email,
          'role': 'teacher',
          'avatar': 'https://example.com/default-avatar.jpg',
          'phone': '+966501234567',
          'department': 'الرياضيات',
          'experience_years': 3,
          'qualification': 'بكالوريوس في الرياضيات',
          'bio': 'معلم رياضيات في المدرسة الثانوية',
          'created_at': DateTime.now().toIso8601String(),
          'last_login_at': DateTime.now().toIso8601String(),
        },
      });

      final Map<String, dynamic> decoded = jsonDecode(fakeJson) as Map<String, dynamic>;
      final int status = decoded['status'] is int ? decoded['status'] as int : 500;
      if (status != 200) {
        final String message = decoded['message']?.toString() ?? 'حدث خطأ غير متوقع';
        return Left(ServerFailure(message: message, statusCode: status));
      }
      final Map<String, dynamic> data = Map<String, dynamic>.from(decoded['data'] as Map);
      return Right(UserModel.fromJson(data));
    } catch (e) {
      return Left(UnknownFailure(message: 'حدث خطأ أثناء معالجة البيانات'));
    }

    // هنا كتلة DioClient الحقيقية (معلّقة) بنفس الشكل دائماً
    // try {
    //   final result = await dioClient.post(
    //     Constants.loginEndpoint,
    //     data: {
    //       'email': email,
    //       'password': password,
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
    //         return Right(UserModel.fromJson(data));
    //       } catch (_) {
    //         return const Left(ValidationFailure(message: 'تنسيق الاستجابة غير صحيح'));
    //       }
    //     },
    //   );
    // } catch (e) {
    //   return Left(UnknownFailure(message: 'تعذر تنفيذ الطلب'));
    // }
  }

  @override
  Future<Either<Failure, UserModel>> checkAuthStatus(int userId) async {
    // *****
    // هنا API وهمي (JSON ثابت) وفق الاستجابة الموحدة { data, message, status }
    // *****
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final String fakeJson = jsonEncode({
        'status': 200,
        'message': 'تم التحقق من حالة المصادقة',
        'data': {
          'id': userId.toString(),
          'name': 'معلم تجريبي',
          'email': 'teacher@example.com',
          'role': 'teacher',
          'avatar': 'https://example.com/default-avatar.jpg',
          'phone': '+966501234567',
          'department': 'الرياضيات',
          'experience_years': 3,
          'qualification': 'بكالوريوس في الرياضيات',
          'bio': 'معلم رياضيات في المدرسة الثانوية',
          'created_at': DateTime.now().toIso8601String(),
          'last_login_at': DateTime.now().toIso8601String(),
        },
      });

      final Map<String, dynamic> decoded = jsonDecode(fakeJson) as Map<String, dynamic>;
      final int status = decoded['status'] is int ? decoded['status'] as int : 500;
      if (status != 200) {
        final String message = decoded['message']?.toString() ?? 'حدث خطأ غير متوقع';
        return Left(ServerFailure(message: message, statusCode: status));
      }
      final Map<String, dynamic> data = Map<String, dynamic>.from(decoded['data'] as Map);
      return Right(UserModel.fromJson(data));
    } catch (e) {
      return Left(UnknownFailure(message: 'حدث خطأ أثناء معالجة البيانات'));
    }

    // هنا كتلة DioClient الحقيقية (معلّقة) بنفس الشكل دائماً
    // try {
    //   final result = await dioClient.get(
    //     Constants.checkAuthEndpoint,
    //     queryParameters: {
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
    //         return Right(UserModel.fromJson(data));
    //       } catch (_) {
    //         return const Left(ValidationFailure(message: 'تنسيق الاستجابة غير صحيح'));
    //       }
    //     },
    //   );
    // } catch (e) {
    //   return Left(UnknownFailure(message: 'تعذر تنفيذ الطلب'));
    // }
  }

  @override
  Future<Either<Failure, void>> logout(int userId) async {
    // *****
    // هنا API وهمي (JSON ثابت) وفق الاستجابة الموحدة { data, message, status }
    // *****
    await Future.delayed(const Duration(milliseconds: 300));
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
      return const Right(null);
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
    //         return const Right(null);
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