import 'package:core/network/network_info.dart';
import 'package:core/network/failures.dart';
import 'package:smart_school/features/schedule/data/data_sources/schedule_local_data_source.dart';

import '../../domain/repositories/schedule_repository.dart';
import '../../domain/entities/schedule_entity.dart';
import '../data_sources/schedule_remote_data_source.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final ScheduleLocalDataSource localDataSource;
  
  ScheduleRepositoryImpl({required this.remoteDataSource, required this.networkInfo, required this.localDataSource});

  @override
  Future<List<ScheduleEntity>> getScheduleForDate(DateTime date) async {
    print('🔍 ScheduleRepositoryImpl: Getting schedule for date: $date');
    try {
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        throw const ConnectionFailure(message: 'الرجاء التحقق من اتصال الإنترنت');
      }
      final studentId = await localDataSource.getId();
      final scheduleModels = await remoteDataSource.getScheduleForDate(date,studentId ?? 0);
      print('🔍 ScheduleRepositoryImpl: Received ${scheduleModels.length} models from remote data source');
      final result = scheduleModels.map((model) => model as ScheduleEntity).toList();
      print('🔍 ScheduleRepositoryImpl: Returning ${result.length} entities');
      return result;
    } catch (e) {
      print('🔍 ScheduleRepositoryImpl: Error getting schedule: $e');
      rethrow;
    }
  }
} 