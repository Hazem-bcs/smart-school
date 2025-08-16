import 'package:auth/domain/usecases/login_usecase.dart';
import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';

class AuthConnectionTest {
  final LoginUseCase loginUseCase;

  AuthConnectionTest({required this.loginUseCase});

  Future<void> testLoginConnection() async {
    print('🔍 بدء اختبار الاتصال مع Laravel backend...');
    
    try {
      final result = await loginUseCase('test@example.com', 'password123');
      
      result.fold(
        (failure) {
          print('❌ فشل في الاتصال: ${failure.message}');
          if (failure is ServerFailure) {
            print('   رمز الخطأ: ${failure.statusCode}');
          } else if (failure is ConnectionFailure) {
            print('   مشكلة في الاتصال بالشبكة');
          }
        },
        (user) {
          print('✅ نجح الاتصال!');
          print('   معرف المستخدم: ${user.id}');
          print('   الاسم: ${user.name}');
          print('   البريد الإلكتروني: ${user.email}');
        },
      );
    } catch (e) {
      print('❌ خطأ غير متوقع: $e');
    }
  }
}
