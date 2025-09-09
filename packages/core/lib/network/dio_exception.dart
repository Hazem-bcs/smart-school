import 'dart:convert';
import 'package:dio/dio.dart';
import 'failures.dart';

Failure handleDioException(DioException error) {
  if (error.response != null && error.response!.statusCode != null) {
    return _handleBadResponse(error);
  }

  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return const ConnectionFailure(message: 'Connection timeout, please try again');
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
      return const ServerFailure(message: 'Bad certificate', statusCode: 400);
    case DioExceptionType.connectionError:
      if (error.response != null) {
        return _handleBadResponse(error);
      }
      return const ConnectionFailure(message: 'Connection error, please try again');
  }
}

Failure _handleBadResponse(DioException error) {
  final statusCode = error.response?.statusCode ?? 500;
  final dynamic data = error.response?.data;

  String? extractedMessage;
  if (data is Map) {
    // Try common message keys from typical APIs
    const possibleKeys = ['message', 'error', 'detail', 'error_description'];
    for (final key in possibleKeys) {
      if (data[key] != null) {
        extractedMessage = data[key].toString();
        break;
      }
    }
    // Fallback to full map string if no key matched
    extractedMessage ??= data.toString();
  } else if (data is List) {
    // If list of errors, stringify first item or the whole list
    extractedMessage = data.isNotEmpty ? data.first.toString() : data.toString();
  } else if (data is String) {
    // If it's a string, try to parse JSON to extract a message, else use the string directly
    final trimmed = data.trim();
    if ((trimmed.startsWith('{') && trimmed.endsWith('}')) ||
        (trimmed.startsWith('[') && trimmed.endsWith(']'))){
      try {
        final decoded = json.decode(trimmed);
        if (decoded is Map && decoded.isNotEmpty) {
          const possibleKeys = ['message', 'error', 'detail', 'error_description'];
          for (final key in possibleKeys) {
            if (decoded[key] != null) {
              extractedMessage = decoded[key].toString();
              break;
            }
          }
          extractedMessage ??= decoded.toString();
        } else if (decoded is List && decoded.isNotEmpty) {
          extractedMessage = decoded.first.toString();
        } else {
          extractedMessage = trimmed;
        }
      } catch (_) {
        extractedMessage = trimmed;
      }
    } else {
      extractedMessage = trimmed;
    }
  }

  final message = extractedMessage ??
      error.response?.statusMessage ??
      'Server error occurred';

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