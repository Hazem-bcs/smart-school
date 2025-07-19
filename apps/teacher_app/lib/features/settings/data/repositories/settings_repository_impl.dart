import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';
import '../../domain/entities/logout_status_entity.dart';
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
  Future<Either<Failure, LogoutStatusEntity>> logout() async {
    try {
      print('📦 Repository: Starting logout process...');

      // 1. محاولة جلب التوكن من التخزين المحلي
      final token = await localDataSource.getAuthToken();
      print('🔑 Retrieved token: ${token ?? "No token found"}');

      // 2. إذا لا يوجد توكن => نعتبره خروج ناجح ونمسح أي بقايا
      if (token == null) {
        print('⚠️ No token found, skipping remote logout.');
        await localDataSource.clearAuthToken();
        return const Right(LogoutStatusEntity(success: true));
      }

      // 3. تسجيل الخروج من السيرفر
      final remoteLogoutResult = await remoteDataSource.logout(token);
      print('✅ Remote logout response: ${remoteLogoutResult.success}');

      // 4. مسح التوكن من التخزين المحلي (دائمًا)
      await localDataSource.clearAuthToken();
      print('🗑️ Token cleared from local storage.');

      return Right(LogoutStatusEntity(success: remoteLogoutResult.success));
    } on ServerFailure catch (e) {
      print('❌ ServerFailure during logout: ${e.message}');
      await localDataSource.clearAuthToken();
      return Left(ServerFailure(message: e.message));
    } on CacheFailure catch (e) {
      print('❌ CacheFailure during logout: ${e.message}');
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      print('❌ Unexpected error during logout: $e');
      await localDataSource.clearAuthToken();
      return Left(ServerFailure(message: "حدث خطأ غير متوقع: ${e.toString()}"));
    }
  }
}
