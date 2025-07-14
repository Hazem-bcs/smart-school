import '../models/zoom_meeting_model.dart';
import '../models/meeting_option_model.dart';

abstract class ZoomMeetingRemoteDataSource {
  Future<ZoomMeetingModel> scheduleMeeting(ZoomMeetingModel meeting);
  Future<List<String>> getAvailableClasses();
  Future<List<MeetingOptionModel>> getMeetingOptions();
}

class ZoomMeetingRemoteDataSourceImpl implements ZoomMeetingRemoteDataSource {
  @override
  Future<ZoomMeetingModel> scheduleMeeting(ZoomMeetingModel meeting) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));
    
    // Mock response - in real app, this would be an API call
    return ZoomMeetingModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      topic: meeting.topic,
      invitedClasses: meeting.invitedClasses,
      scheduledDate: meeting.scheduledDate,
      scheduledTime: meeting.scheduledTime,
      enableWaitingRoom: meeting.enableWaitingRoom,
      recordAutomatically: meeting.recordAutomatically,
      meetingUrl: 'https://zoom.us/j/123456789',
      meetingId: '123456789',
      password: '123456',
    );
  }

  @override
  Future<List<String>> getAvailableClasses() async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Mock data - in real app, this would come from API
    return [
      'Math 101',
      'History 202', 
      'Science 303',
      'Art Elective',
      'English 404',
      'Physics 505'
    ];
  }

  @override
  Future<List<MeetingOptionModel>> getMeetingOptions() async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Mock data - in real app, this would come from API
    return [
      MeetingOptionModel(
        id: 'waiting_room',
        title: 'Enable Waiting Room',
        isEnabled: true,
        description: 'Participants will wait in a virtual waiting room until you admit them',
      ),
      MeetingOptionModel(
        id: 'record_meeting',
        title: 'Record meeting automatically',
        isEnabled: false,
        description: 'Automatically record the meeting when it starts',
      ),
    ];
  }
} 