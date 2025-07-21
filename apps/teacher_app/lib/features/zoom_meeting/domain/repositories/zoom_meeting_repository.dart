import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';
import '../entities/zoom_meeting_entity.dart';
import '../entities/meeting_option_entity.dart';

abstract class ZoomMeetingRepository {
  Future<Either<Failure, ZoomMeetingEntity>> scheduleMeeting(ZoomMeetingEntity meeting);
  Future<Either<Failure, List<String>>> getAvailableClasses();
  Future<Either<Failure, List<MeetingOptionEntity>>> getMeetingOptions();
} 