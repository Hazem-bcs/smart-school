import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';
import '../entities/zoom_meeting_entity.dart';
import '../repositories/zoom_meeting_repository.dart';

class ScheduleMeetingUseCase {
  final ZoomMeetingRepository repository;

  ScheduleMeetingUseCase(this.repository);

  Future<Either<Failure, ZoomMeetingEntity>> call(ZoomMeetingEntity meeting) async {
    return await repository.scheduleMeeting(meeting);
  }
} 