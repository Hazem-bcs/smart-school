import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'failures.dart';
import 'dio_exception.dart';
import 'interceptors.dart';

class DioClient {
  final Dio dio;
  final int maxRetries;

  DioClient({
    required String baseUrl,
    Future<String?> Function()? getToken,
    this.maxRetries = 3,
    bool enableLogging = false,
  }) : dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          responseType: ResponseType.json,
        )) {
    if (getToken != null) {
      dio.interceptors.add(AuthInterceptor(getToken: getToken));
    }
    if (enableLogging) {
      dio.interceptors.add(AppLogInterceptor());
  }
  }

  Future<Either<Failure, Response>> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    return _request(
      () => dio.get(
          url,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress,
      ),
    );
      }

  Future<Either<Failure, Response>> post(
    String url, {
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return _request(
      () => dio.post(
          url,
          data: data,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
      ),
    );
      }

  Future<Either<Failure, Response>> put(
    String url, {
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return _request(
      () => dio.put(
          url,
          data: data,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
      ),
    );
      }

  Future<Either<Failure, Response>> delete(
    String url, {
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _request(
      () => dio.delete(
        url,
        data: data,
        options: options,
        cancelToken: cancelToken,
      ),
    );
  }

  Future<Either<Failure, Response>> _request(Future<Response> Function() requestFn) async {
    int attempt = 0;
    while (true) {
      try {
        final response = await requestFn();
        return Right(response);
      } on DioException catch (e) {
        if (++attempt >= maxRetries) {
          return Left(handleDioException(e));
        }
        await Future.delayed(const Duration(seconds: 1));
      } catch (e) {
        return Left(UnknownFailure(message: e.toString()));
      }
    }
  }
}