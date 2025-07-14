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

  HomeRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ClassEntity>> getClasses() async {
    try {
      final classModels = await remoteDataSource.getClasses();
      return classModels.map((model) => _mapClassModelToEntity(model)).toList();
    } catch (e) {
      throw Exception('Failed to get classes: $e');
    }
  }

  @override
  Future<List<AssignmentEntity>> getAssignments() async {
    try {
      final assignmentModels = await remoteDataSource.getAssignments();
      return assignmentModels.map((model) => _mapAssignmentModelToEntity(model)).toList();
    } catch (e) {
      throw Exception('Failed to get assignments: $e');
    }
  }

  @override
  Future<List<NotificationEntity>> getNotifications() async {
    try {
      final notificationModels = await remoteDataSource.getNotifications();
      return notificationModels.map((model) => _mapNotificationModelToEntity(model)).toList();
    } catch (e) {
      throw Exception('Failed to get notifications: $e');
    }
  }

  @override
  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await remoteDataSource.markNotificationAsRead(notificationId);
    } catch (e) {
      throw Exception('Failed to mark notification as read: $e');
    }
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