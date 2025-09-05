import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';
import '../entities/zoom_meeting_entity.dart';
import '../repositories/zoom_meeting_repository.dart';

class GetScheduledMeetingsUseCase {
  final ZoomMeetingRepository repository;

  GetScheduledMeetingsUseCase(this.repository);

  Future<Either<Failure, List<ZoomMeetingEntity>>> call() async {
    return await repository.getScheduledMeetings();
  }
}


