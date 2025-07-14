import '../../domain/entities/zoom_meeting_entity.dart';
import '../../domain/entities/meeting_option_entity.dart';
import '../../domain/repositories/zoom_meeting_repository.dart';
import '../data_sources/zoom_meeting_remote_data_source.dart';
import '../models/zoom_meeting_model.dart';
import '../models/meeting_option_model.dart';

class ZoomMeetingRepositoryImpl implements ZoomMeetingRepository {
  final ZoomMeetingRemoteDataSource remoteDataSource;

  ZoomMeetingRepositoryImpl(this.remoteDataSource);

  @override
  Future<ZoomMeetingEntity> scheduleMeeting(ZoomMeetingEntity meeting) async {
    try {
      final meetingModel = _mapEntityToModel(meeting);
      final resultModel = await remoteDataSource.scheduleMeeting(meetingModel);
      return _mapModelToEntity(resultModel);
    } catch (e) {
      throw Exception('Failed to schedule meeting: $e');
    }
  }

  @override
  Future<List<String>> getAvailableClasses() async {
    try {
      return await remoteDataSource.getAvailableClasses();
    } catch (e) {
      throw Exception('Failed to get available classes: $e');
    }
  }

  @override
  Future<List<MeetingOptionEntity>> getMeetingOptions() async {
    try {
      final optionModels = await remoteDataSource.getMeetingOptions();
      return optionModels.map((model) => _mapOptionModelToEntity(model)).toList();
    } catch (e) {
      throw Exception('Failed to get meeting options: $e');
    }
  }

  // Mapping methods
  ZoomMeetingModel _mapEntityToModel(ZoomMeetingEntity entity) {
    return ZoomMeetingModel(
      id: entity.id,
      topic: entity.topic,
      invitedClasses: entity.invitedClasses,
      scheduledDate: entity.scheduledDate,
      scheduledTime: entity.scheduledTime,
      enableWaitingRoom: entity.enableWaitingRoom,
      recordAutomatically: entity.recordAutomatically,
      meetingUrl: entity.meetingUrl,
      meetingId: entity.meetingId,
      password: entity.password,
    );
  }

  ZoomMeetingEntity _mapModelToEntity(ZoomMeetingModel model) {
    return ZoomMeetingEntity(
      id: model.id,
      topic: model.topic,
      invitedClasses: model.invitedClasses,
      scheduledDate: model.scheduledDate,
      scheduledTime: model.scheduledTime,
      enableWaitingRoom: model.enableWaitingRoom,
      recordAutomatically: model.recordAutomatically,
      meetingUrl: model.meetingUrl,
      meetingId: model.meetingId,
      password: model.password,
    );
  }

  MeetingOptionEntity _mapOptionModelToEntity(MeetingOptionModel model) {
    return MeetingOptionEntity(
      id: model.id,
      title: model.title,
      isEnabled: model.isEnabled,
      description: model.description,
    );
  }
} 