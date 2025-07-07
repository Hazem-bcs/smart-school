import 'package:dartz/dartz.dart';
import '../../domain/entities/password_change_request.dart';
import '../../domain/repositories/password_repository.dart';
import '../datasources/password_remote_datasource.dart';
import '../models/password_change_request_model.dart';

class PasswordRepositoryImpl implements PasswordRepository {
  final PasswordRemoteDataSource remoteDataSource;

  PasswordRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, void>> changePassword(PasswordChangeRequest request) async {
    try {
      final model = PasswordChangeRequestModel.fromEntity(request);
      await remoteDataSource.changePassword(model);
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }
} 