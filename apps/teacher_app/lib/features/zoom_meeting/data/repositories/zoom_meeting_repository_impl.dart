import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';
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
  Future<Either<Failure, ZoomMeetingEntity>> scheduleMeeting(ZoomMeetingEntity meeting) async {
    final meetingModel = ZoomMeetingModel.fromEntity(meeting);
    final result = await remoteDataSource.scheduleMeeting(meetingModel);
    return result.fold(
      (failure) => Left(failure),
      (model) => Right(model.toEntity()),
    );
  }

  @override
  Future<Either<Failure, List<String>>> getAvailableClasses() async {
    final result = await remoteDataSource.getAvailableClasses();
    return result.fold(
      (failure) => Left(failure),
      (classes) => Right(classes),
    );
  }

  @override
  Future<Either<Failure, List<MeetingOptionEntity>>> getMeetingOptions() async {
    final result = await remoteDataSource.getMeetingOptions();
    return result.fold(
      (failure) => Left(failure),
      (optionModels) => Right(optionModels.map((model) => model.toEntity()).toList()),
    );
  }
} 