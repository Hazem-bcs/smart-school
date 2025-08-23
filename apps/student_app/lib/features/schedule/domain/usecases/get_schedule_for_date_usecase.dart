import '../repositories/schedule_repository.dart';
import '../entities/schedule_entity.dart';

class GetScheduleForDateUseCase {
  final ScheduleRepository repository;

  GetScheduleForDateUseCase(this.repository);

  Future<List<ScheduleEntity>> call(DateTime date) async {
    print('🔍 GetScheduleForDateUseCase: Calling repository for date: $date');
    final result = await repository.getScheduleForDate(date);
    print('🔍 GetScheduleForDateUseCase: Received ${result.length} entities from repository');
    return result;
  }
} 