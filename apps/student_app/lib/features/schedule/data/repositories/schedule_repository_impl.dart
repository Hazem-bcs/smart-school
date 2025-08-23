import 'package:core/network/network_info.dart';

import '../../domain/repositories/schedule_repository.dart';
import '../../domain/entities/schedule_entity.dart';
import '../data_sources/schedule_remote_data_source.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ScheduleRepositoryImpl({required this.remoteDataSource, required this.networkInfo});

  @override
  Future<List<ScheduleEntity>> getScheduleForDate(DateTime date) async {
    print('🔍 ScheduleRepositoryImpl: Getting schedule for date: $date');
    try {
      final scheduleModels = await remoteDataSource.getScheduleForDate(date);
      print('🔍 ScheduleRepositoryImpl: Received ${scheduleModels.length} models from remote data source');
      final result = scheduleModels.map((model) => model as ScheduleEntity).toList();
      print('🔍 ScheduleRepositoryImpl: Returning ${result.length} entities');
      return result;
    } catch (e) {
      print('🔍 ScheduleRepositoryImpl: Error getting schedule: $e');
      throw Exception('Failed to get schedule for date: $e');
    }
  }
} 