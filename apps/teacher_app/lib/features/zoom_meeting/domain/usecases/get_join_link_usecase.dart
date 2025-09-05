import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';
import '../repositories/zoom_meeting_repository.dart';

class GetJoinLinkUseCase {
  final ZoomMeetingRepository repository;

  GetJoinLinkUseCase(this.repository);

  Future<Either<Failure, String>> call(String meetingId) async {
    return await repository.getJoinLink(meetingId);
  }
}


