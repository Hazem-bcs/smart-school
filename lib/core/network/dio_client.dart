import 'package:dio/dio.dart';

import '../constant.dart';

class DioClient {
  final Dio dio;
  final int maxRetries = 3;
  DioClient({required this.dio}) {
    dio
      ..options.baseUrl = Constants.baseUrl
      ..options.connectTimeout = const Duration(seconds: 30)
      ..options.receiveTimeout = const Duration(seconds: 30)
      ..options.responseType = ResponseType.json
      ..interceptors.add(LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
      ));
  }

  /// طلب GET
  Future<Response> get(String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    int attempt = 0;
    while (true) {
      try {
        return await dio.get(
          url,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress,
        );
      } catch (e) {
        if (++attempt >= maxRetries) rethrow;
        await Future.delayed(const Duration(seconds: 1));
      }
    }
  }

  /// طلب POST
  Future<Response> post(String url, {
    Map<String, dynamic>? data,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    int attempt = 0;
    while (true) {
      try {
        return await dio.post(
          url,
          data: data,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
        );
      }
      catch
      (e) {
        if (++attempt >= maxRetries) rethrow;
        await Future.delayed(const Duration(seconds: 1));
      }
    }
  }

  /// طلب PUT
  Future<Response> put(String url, {
    Map<String, dynamic>? data,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    int attempt = 0;
    while (true) {
      try {
        return await dio.put(
          url,
          data: data,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
        );
      }
      catch (e) {
        if (++attempt >= maxRetries) rethrow;
        await Future.delayed(const Duration(seconds: 1));
      }
    }
  }

  /// طلب DELETE
  Future<Response> delete(String url, {
    Map<String, dynamic>? data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    int attempt = 0;
    while (true) {
      try {
        return await dio.delete(
          url,
          data: data,
          options: options,
          cancelToken: cancelToken,
        );
      }
      catch (e) {
        if (++attempt >= maxRetries) rethrow;
        await Future.delayed(const Duration(seconds: 1));
      }
    }
  }
}
