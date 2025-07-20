import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';
import '../repositories/zoom_meeting_repository.dart';

class GetAvailableClassesUseCase {
  final ZoomMeetingRepository repository;

  GetAvailableClassesUseCase(this.repository);

  Future<Either<Failure, List<String>>> call() async {
    return await repository.getAvailableClasses();
  }
} 