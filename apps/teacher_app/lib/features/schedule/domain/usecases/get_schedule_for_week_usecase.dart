import '../repositories/schedule_repository.dart';
import '../entities/schedule_entity.dart';

class GetScheduleForWeekUseCase {
  final ScheduleRepository repository;

  GetScheduleForWeekUseCase(this.repository);

  Future<List<ScheduleEntity>> call(DateTime weekStart) async {
    return await repository.getScheduleForWeek(weekStart);
  }
} 