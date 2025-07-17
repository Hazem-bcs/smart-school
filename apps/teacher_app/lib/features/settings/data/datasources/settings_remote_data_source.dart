// lib/features/settings/data/datasources/settings_remote_data_source.dart

// import 'package:your_app_name/core/error/failures.dart'; // قم بتغيير 'core/network/failures.dart' إلى هذا المسار الصحيح
import 'package:core/network/failures.dart';
import 'package:dio/dio.dart'; // هذه المكتبة يمكن أن تبقى، لكن لن تستخدم للـ mock
import '../models/logout_model.dart';

abstract class SettingsRemoteDataSource {
  Future<LogoutModel> logout(String token);
}

class SettingsRemoteDataSourceImpl implements SettingsRemoteDataSource {
  final Dio dio; // يمكن الإبقاء عليها في الـ constructor حتى لو لم تستخدم حالياً
  final String baseUrl; // يمكن الإبقاء عليها في الـ constructor

  SettingsRemoteDataSourceImpl({required this.dio, required this.baseUrl});

  @override
  Future<LogoutModel> logout(String token) async {
    // // // // // هذا الجزء هو لعملية الـ API الفعلية - تم التعليق عليه // // // // //
    // try {
    //   dio.options.headers['Content-Type'] = 'application/json';
    //   dio.options.headers['Authorization'] = 'Bearer $token';

    //   final response = await dio.post('$baseUrl/logout');

    //   if (response.statusCode == 200) {
    //     // يمكنك تحليل response.data إذا كان الخادم يرسل JSON عند النجاح
    //     // على سبيل المثال: return LogoutModel.fromJson(response.data);
    //     return const LogoutModel(success: true); // نفترض النجاح بناءً على 200 OK
    //   } else {
    //     // إذا كان هناك جسم استجابة بخطأ من الخادم
    //     String errorMessage = "فشل الخادم: ${response.statusCode}";
    //     if (response.data != null &&
    //         response.data is Map &&
    //         response.data.containsKey('message')) {
    //       errorMessage = response.data['message'];
    //     }
    //     throw ServerFailure(message: errorMessage);
    //   }
    // } on DioException catch (e) {
    //   String errorMessage = "خطأ في الشبكة";
    //   if (e.response != null) {
    //     errorMessage = "خطأ في الخادم: ${e.response?.statusCode}";
    //     if (e.response?.data != null &&
    //         e.response?.data is Map &&
    //         e.response?.data.containsKey('message')) {
    //       errorMessage = e.response?.data['message'];
    //     }
    //   } else {
    //     errorMessage = "لا يوجد اتصال بالإنترنت أو خطأ غير معروف.";
    //   }
    //   throw ServerFailure(message: errorMessage);
    // } catch (e) {
    //   throw ServerFailure(message: "حدث خطأ غير متوقع: ${e.toString()}");
    // }
    // // // // // نهاية جزء الـ API الفعلي // // // // //

    // // // // // هذا الجزء هو لإنشاء بيانات وهمية (Mock Data) // // // // //
    print('🚨 Mock Logout: استدعاء تسجيل الخروج. Token: $token');
    await Future.delayed(const Duration(seconds: 2)); // محاكاة لـتأخير الشبكة

    // يمكنك تغيير 'true' إلى 'false' لمحاكاة فشل في تسجيل الخروج
    // وفي حالة الفشل، يمكنك رمي ServerFailure لمحاكاة خطأ من الـ backend
    bool mockSuccess = true; // اجعلها true لمحاكاة تسجيل الخروج الناجح
    // bool mockSuccess = false; // اجعلها false لمحاكاة فشل تسجيل الخروج

    if (mockSuccess) {
      print('✅ Mock Logout: تم تسجيل الخروج بنجاح!');
      return const LogoutModel(success: true);
    } else {
      print('❌ Mock Logout: فشل تسجيل الخروج الوهمي!');
      throw const ServerFailure(message: 'فشل تسجيل الخروج الوهمي من الخادم.');
    }
  }
}