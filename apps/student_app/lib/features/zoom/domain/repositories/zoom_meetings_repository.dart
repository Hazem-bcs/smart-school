import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';

import '../../domain/entities/zoom_meeting.dart';

abstract class ZoomMeetingsRepository {
  Future<Either<Failure, List<ZoomMeeting>>> getAllZoomMeetings();
}
