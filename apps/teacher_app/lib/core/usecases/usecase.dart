// lib/core/usecases/usecase.dart

import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart'; // تأكد من استيراد equatable هنا


// UseCase يأخذ بارامترات
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

// UseCase لا يأخذ بارامترات (مثل Logout)
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}