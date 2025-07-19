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
    // ملاحظة: الكود التالي وهمي فقط، عند الربط مع الـ backend استبدله بطلب فعلي
    await Future.delayed(const Duration(milliseconds: 800));
    // مثال على شكل الـ JSON المتوقع من السيرفر
    final Map<String, dynamic> response = {
      'success': true,
      'statuscode': 200,
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
      'message': 'تم تسجيل الدخول بنجاح',
    };

    // منطق معالجة الاستجابة
    if (response['statuscode'] == 200) {
      final user = UserModel.fromJson(response['data']);
      return Right(user);
    } else {
      // يمكنك تخصيص أنواع الأخطاء حسب statuscode أو الرسالة
      return Left(ServerFailure(message: response['message'] ?? 'خطأ غير معروف'));
    }
  }

  @override
  Future<Either<Failure, UserModel>> checkAuthStatus(int userId) async {
    // ملاحظة: الكود التالي وهمي فقط، عند الربط مع الـ backend استبدله بطلب فعلي
    await Future.delayed(const Duration(milliseconds: 500));
    // مثال على شكل الـ JSON المتوقع من السيرفر
    final Map<String, dynamic> response = {
      'success': true,
      'statuscode': 200,
      'data': {
        'id': '1',
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
      'message': 'تم التحقق من حالة المصادقة بنجاح',
    };

    // منطق معالجة الاستجابة
    if (response['statuscode'] == 200) {
      final user = UserModel.fromJson(response['data']);
      return Right(user);
    } else {
      return Left(ServerFailure(message: response['message'] ?? 'خطأ غير معروف'));
    }
  }

  @override
  Future<Either<Failure, void>> logout(int userId) async {
    // ملاحظة: الكود التالي وهمي فقط، عند الربط مع الـ backend استبدله بطلب فعلي
    await Future.delayed(const Duration(milliseconds: 300));
    // مثال على شكل الـ JSON المتوقع من السيرفر
    final Map<String, dynamic> response = {
      'success': true,
      'statuscode': 200,
      'message': 'تم تسجيل الخروج بنجاح',
    };

    // منطق معالجة الاستجابة
    if (response['statuscode'] == 200) {
      return const Right(null);
    } else {
      return Left(ServerFailure(message: response['message'] ?? 'خطأ غير معروف'));
    }
  }
} 