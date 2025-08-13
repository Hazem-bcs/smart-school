import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/entities/logout_entity.dart';
import '../data_sources/remote/settings_remote_data_source.dart';
import '../data_sources/local/settings_local_data_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsRemoteDataSource remoteDataSource;
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, LogoutEntity>> logout() async {
    try {
      
      final userId = await localDataSource.getUserId();
      
      if (userId == null || userId.isEmpty) {
        await localDataSource.clearUserId();
        return Right(const LogoutEntity(
          success: true,
          message: 'تم تسجيل الخروج بنجاح',
        ));
      }
      
      // Get logout result from remote data source
      final logoutResult = await remoteDataSource.logout(userId);
      
      return logoutResult.fold(
        (failure) => Left(failure),
        (logoutModel) async {
          // If logout is successful, clear local user data
          if (logoutModel.success) {
            try {
              await localDataSource.clearUserId();
            } catch (e) {
              // Even if clearing local data fails, we still return success
              // because the server logout was successful
            }
          }
          
          return Right(logoutModel);
        },
      );
    } catch (e) {
      return Left(ServerFailure(message: 'حدث خطأ أثناء تسجيل الخروج: ${e.toString()}'));
    }
  }
} 