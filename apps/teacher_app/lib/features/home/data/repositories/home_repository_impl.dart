import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';
import 'package:teacher_app/core/local_data_source.dart';
import '../../domain/entities/class_entity.dart';
import '../../domain/entities/assignment_entity.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../data_sources/home_remote_data_source.dart';
import '../models/class_model.dart';
import '../models/assignment_model.dart';
import '../models/notification_model.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;
  HomeRepositoryImpl(HomeRemoteDataSource homeRemoteDataSource, {required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Either<Failure, List<ClassEntity>>> getClasses() async {
    final teacherId = await localDataSource.getUserId() ?? 0;
    final result = await remoteDataSource.getClasses(teacherId);
    return result.map(
      (models) => models.map(_mapClassModelToEntity).toList(),
    );
  }

  @override
  Future<Either<Failure, List<AssignmentEntity>>> getAssignments() async {
    final result = await remoteDataSource.getAssignments();
    return result.map(
      (models) => models.map(_mapAssignmentModelToEntity).toList(),
    );
  }

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications() async {
    final result = await remoteDataSource.getNotifications();
    return result.map(
      (models) => models.map(_mapNotificationModelToEntity).toList(),
    );
  }

  @override
  Future<Either<Failure, Unit>> markNotificationAsRead(String notificationId) async {
    return remoteDataSource.markNotificationAsRead(notificationId);
  }

  // Mapping methods
  ClassEntity _mapClassModelToEntity(ClassModel model) {
    return ClassEntity(
      id: model.id,
      title: model.title,
      imageUrl: model.imageUrl,
      studentCount: model.studentCount,
      subject: model.subject,
    );
  }

  AssignmentEntity _mapAssignmentModelToEntity(AssignmentModel model) {
    return AssignmentEntity(
      id: model.id,
      title: model.title,
      subtitle: model.subtitle,
      dueDate: model.dueDate,
      status: model.status,
    );
  }

  NotificationEntity _mapNotificationModelToEntity(NotificationModel model) {
    return NotificationEntity(
      id: model.id,
      title: model.title,
      subtitle: model.subtitle,
      timestamp: model.timestamp,
      isRead: model.isRead,
    );
  }
} 