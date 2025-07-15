import 'package:dio/dio.dart';

/// Interceptor لإضافة التوكن أو أي ترويسات عامة
class AuthInterceptor extends Interceptor {
  final Future<String?> Function() getToken;

  AuthInterceptor({required this.getToken});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}

/// Interceptor للـ logging (يُفعل فقط في التطوير)
class AppLogInterceptor extends LogInterceptor {
  AppLogInterceptor()
      : super(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
        );
} 