import '../repositories/schedule_repository.dart';
import '../entities/schedule_entity.dart';

class GetScheduleForDateUseCase {
  final ScheduleRepository repository;

  GetScheduleForDateUseCase(this.repository);

  Future<List<ScheduleEntity>> call(DateTime date) async {
    return await repository.getScheduleForDate(date);
  }
} 