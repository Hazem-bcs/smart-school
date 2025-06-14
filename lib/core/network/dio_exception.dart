
import 'package:dio/dio.dart';

import 'failures.dart';

Failure handleDioException(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return const ConnectionFailure(
          message: 'Connection timeout, please try again');
    case DioExceptionType.badResponse:
      return _handleBadResponse(error);
    case DioExceptionType.cancel:
      return const ServerFailure(message: 'Request canceled', statusCode: -1);
    case DioExceptionType.unknown:
      if (error.message?.contains('SocketException') ?? false) {
        return const ConnectionFailure(message: 'No internet connection');
      }
      return const UnknownFailure(message: 'Unexpected error occurred');
    case DioExceptionType.badCertificate:
      return const ServerFailure(
          message: 'Bad certificate', statusCode: 400);
    case DioExceptionType.connectionError:
      return const ConnectionFailure(
          message: 'Connection error, please try again');
  }
}

Failure _handleBadResponse(DioException error) {
  final statusCode = error.response?.statusCode;
  final message = error.response?.statusMessage ?? 'Server error occurred';

  switch (statusCode) {
    case 400:
      return ValidationFailure(message: message);
    case 401:
      return ServerFailure(message: 'Unauthorized', statusCode: 401);
    case 403:
      return ServerFailure(message: 'Forbidden', statusCode: 403);
    case 404:
      return ServerFailure(message: 'Not found', statusCode: 404);
    case 500:
      return ServerFailure(message: 'Internal server error', statusCode: 500);
    default:
      return ServerFailure(message: message, statusCode: statusCode);
  }
}