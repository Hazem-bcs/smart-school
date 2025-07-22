// lib/data/repositories/zoom_meetings_repository_impl.dart

import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../domain/entities/zoom_meeting.dart';
import '../../domain/repositories/zoom_meetings_repository.dart';
import '../datasources/zoom_meetings_remote_data_source.dart';

class ZoomMeetingsRepositoryImpl implements ZoomMeetingsRepository {
  final ZoomMeetingsRemoteDataSource remoteDataSource;

  ZoomMeetingsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ZoomMeeting>>> getAllZoomMeetings() async {
    try {
      final zoomMeetingModels = await remoteDataSource.getAllZoomMeetings();
      return Right(zoomMeetingModels.map((model) => model.toEntity()).toList());
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError || e.type == DioExceptionType.connectionTimeout) {
        // استخدام 'const' هنا
        return Left(const ConnectionFailure(message: "لا يوجد اتصال بالإنترنت. يرجى التحقق من اتصالك."));
      } else if (e.type == DioExceptionType.badResponse) {
        final String errorMessage = e.response?.data['message'] ?? "حدث خطأ من الخادم.";
        final int? statusCode = e.response?.statusCode;

        if (statusCode == 401) {
          // استخدام 'const' هنا
          return Left(const UnAuthenticated(message: "غير مصرح لك بالوصول. يرجى تسجيل الدخول مجددًا."));
        } else if (statusCode != null && statusCode >= 400 && statusCode < 500) {
          // استخدام 'const' هنا (إذا كان errorMessage ثابتًا)
          return Left(ValidationFailure(message: errorMessage)); // إذا كانت errorMessage ديناميكية فلا تستخدم const
        } else if (statusCode != null && statusCode >= 500) {
          // استخدام 'const' هنا (إذا كان errorMessage ثابتًا)
          return Left(ServerFailure(message: errorMessage, statusCode: statusCode)); // إذا كانت errorMessage ديناميكية فلا تستخدم const
        }
      }
      // استخدام 'const' هنا (إذا كان e.message ثابتًا)
      return Left(UnknownFailure(message: e.message ?? "حدث خطأ غير متوقع في الاتصال.")); // إذا كانت ديناميكية فلا تستخدم const
    } catch (e) {
      // استخدام 'const' هنا (إذا كان e.toString() ثابتًا)
      return Left(UnknownFailure(message: "حدث خطأ غير متوقع: ${e.toString()}")); // إذا كانت ديناميكية فلا تستخدم const
    }
  }
}