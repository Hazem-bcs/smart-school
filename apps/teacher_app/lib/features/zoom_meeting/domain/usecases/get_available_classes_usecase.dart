import '../repositories/zoom_meeting_repository.dart';

class GetAvailableClassesUseCase {
  final ZoomMeetingRepository repository;

  GetAvailableClassesUseCase(this.repository);

  Future<List<String>> call() async {
    return await repository.getAvailableClasses();
  }
} 