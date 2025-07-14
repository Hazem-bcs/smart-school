import '../repositories/schedule_repository.dart';
import '../entities/schedule_entity.dart';

class CreateScheduleUseCase {
  final ScheduleRepository repository;

  CreateScheduleUseCase(this.repository);

  Future<ScheduleEntity> call(ScheduleEntity schedule) async {
    return await repository.createSchedule(schedule);
  }
} 