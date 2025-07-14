import '../entities/class_entity.dart';
import '../entities/assignment_entity.dart';
import '../entities/notification_entity.dart';

abstract class HomeRepository {
  Future<List<ClassEntity>> getClasses();
  Future<List<AssignmentEntity>> getAssignments();
  Future<List<NotificationEntity>> getNotifications();
  Future<void> markNotificationAsRead(String notificationId);
} 