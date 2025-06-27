import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure({required this.message, this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

// لفشل الاتصال بالإنترنت
class ConnectionFailure extends Failure {
  const ConnectionFailure({required super.message});

  @override
  List<Object?> get props => [message];
}

// لأخطاء الخادم
class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

// لأخطاء التحقق من الصحة
class ValidationFailure extends Failure {
  const ValidationFailure({required super.message});

  @override
  List<Object?> get props => [message];
}
// لا يوجد توكن مخزن
class CacheFailure extends Failure {
  const CacheFailure({required super.message});

  @override
  List<Object?> get props => [message];
}

// لأخطاء غير معروفة
class UnknownFailure extends Failure {
  const UnknownFailure({required super.message});

  @override
  List<Object?> get props => [message];
}
