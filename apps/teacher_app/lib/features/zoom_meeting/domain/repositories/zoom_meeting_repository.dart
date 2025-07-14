import '../entities/zoom_meeting_entity.dart';
import '../entities/meeting_option_entity.dart';

abstract class ZoomMeetingRepository {
  Future<ZoomMeetingEntity> scheduleMeeting(ZoomMeetingEntity meeting);
  Future<List<String>> getAvailableClasses();
  Future<List<MeetingOptionEntity>> getMeetingOptions();
} 