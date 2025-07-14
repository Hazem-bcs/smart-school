import '../entities/meeting_option_entity.dart';
import '../repositories/zoom_meeting_repository.dart';

class GetMeetingOptionsUseCase {
  final ZoomMeetingRepository repository;

  GetMeetingOptionsUseCase(this.repository);

  Future<List<MeetingOptionEntity>> call() async {
    return await repository.getMeetingOptions();
  }
} 