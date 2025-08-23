import 'package:core/domain/entities/user_entity.dart';
import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_data_source.dart';
import '../datasources/settings_remote_data_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsRemoteDataSource remoteDataSource;
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, UserEntity>> getStudentProfile() async {
    try {
      final studentId = await localDataSource.getId();
      final userModel = await remoteDataSource.getStudentProfile(studentId ?? 0);
      return userModel.fold(
        (failure) => Left(failure),
        (user) => Right(user.toEntity()),
      );
    } catch (e) {
      return Left(ServerFailure(message: "حدث خطأ غير متوقع: ${e.toString()}"));
    }
  }
}
