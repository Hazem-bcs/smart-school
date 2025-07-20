import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';
import '../../models/logout_model.dart';

abstract class SettingsRemoteDataSource {
  Future<Either<Failure, LogoutModel>> logout(String userId);
}

class SettingsRemoteDataSourceImpl implements SettingsRemoteDataSource {
  @override
  Future<Either<Failure, LogoutModel>> logout(String userId) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 1500));
    
    // Simulate random error (15% chance)
    if (DateTime.now().millisecondsSinceEpoch % 7 == 0) {
      return Left(ServerFailure(message: 'فشل في الاتصال بالخادم، يرجى المحاولة مرة أخرى'));
    }

    // Simulate network timeout (5% chance)
    if (DateTime.now().millisecondsSinceEpoch % 20 == 0) {
      return Left(ServerFailure(message: 'انتهت مهلة الاتصال، يرجى التحقق من اتصال الإنترنت'));
    }

    try {
      // Mock successful response
      final mockResponse = {
        'success': true,
        'message': 'تم تسجيل الخروج بنجاح',
        'user_id': userId,
      };

      return Right(LogoutModel.fromJson(mockResponse));
    } catch (e) {
      return Left(ServerFailure(message: 'خطأ في تحليل استجابة الخادم'));
    }
  }
} 