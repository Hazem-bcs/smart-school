import 'package:core/network/dio_client.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login(String email, String password);
  Future<Map<String, dynamic>> checkAuthStatus(String token);
  Future<void> logout(String token);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    // محاكاة تأخير الشبكة
    await Future.delayed(const Duration(milliseconds: 800));
    
    // قبول أي بيانات دخول وإرجاع بيانات وهمية عامة
    return {
      'success': true,
      'message': 'تم تسجيل الدخول بنجاح',
      'data': {
        'user': {
          'id': 1,
          'name': 'معلم تجريبي',
          'email': email,
          'role': 'teacher',
          'profile_photo': 'https://example.com/default-avatar.jpg',
          'phone': '+966501234567',
          'department': 'الرياضيات',
          'experience_years': 3,
          'qualification': 'بكالوريوس في الرياضيات',
          'bio': 'معلم رياضيات في المدرسة الثانوية',
        },
        'token': 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
        'refresh_token': 'mock_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
        'expires_at': DateTime.now().add(const Duration(hours: 1)).toIso8601String(),
      }
    };
  }

  @override
  Future<Map<String, dynamic>> checkAuthStatus(String token) async {
    // محاكاة تأخير الشبكة
    await Future.delayed(const Duration(milliseconds: 500));
    
    // قبول أي توكن وإرجاع بيانات وهمية عامة
    return {
      'success': true,
      'message': 'التوكن صالح',
      'data': {
        'user': {
          'id': 1,
          'name': 'معلم تجريبي',
          'email': 'teacher@example.com',
          'role': 'teacher',
          'profile_photo': 'https://example.com/default-avatar.jpg',
          'phone': '+966501234567',
          'department': 'الرياضيات',
          'experience_years': 3,
          'qualification': 'بكالوريوس في الرياضيات',
          'bio': 'معلم رياضيات في المدرسة الثانوية',
        },
        'is_valid': true,
        'expires_at': DateTime.now().add(const Duration(hours: 1)).toIso8601String(),
      }
    };
  }

  @override
  Future<void> logout(String token) async {
    // محاكاة تأخير الشبكة
    await Future.delayed(const Duration(milliseconds: 300));
    
    // محاكاة تسجيل الخروج بنجاح
    print('تم تسجيل الخروج بنجاح للمستخدم مع التوكن: ${token.substring(0, 10)}...');
    
    // يمكن إضافة منطق إضافي هنا مثل مسح البيانات المحلية
    // أو إرسال إشعار للسيرفر (عندما يكون متاحاً)
  }
} 