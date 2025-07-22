import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';
import '../../domain/entities/zoom_meeting.dart';
import '../../domain/repositories/zoom_meetings_repository.dart';

class GetAllZoomMeetingsUseCase {
  final ZoomMeetingsRepository repository;

  GetAllZoomMeetingsUseCase({required this.repository});

  Future<Either<Failure, List<ZoomMeeting>>> call() async {
    return await repository.getAllZoomMeetings();
  }
}
