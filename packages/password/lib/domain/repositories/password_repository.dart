import 'package:dartz/dartz.dart';
import '../entities/password_change_request.dart';

abstract class PasswordRepository {
  Future<Either<String, void>> changePassword(PasswordChangeRequest request);
} 