import '../models/class_model.dart';
import '../models/assignment_model.dart';
import '../models/notification_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<ClassModel>> getClasses();
  Future<List<AssignmentModel>> getAssignments();
  Future<List<NotificationModel>> getNotifications();
  Future<void> markNotificationAsRead(String notificationId);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  @override
  Future<List<ClassModel>> getClasses() async {
    // Mock data - replace with actual API call
    await Future.delayed(const Duration(seconds: 1));
    
    return [
      const ClassModel(
        id: '1',
        title: 'Math 101',
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuD9w7tCpSPAzZbbubs-iE5xRO73QdEsyxz7VIrvaDOC2W-5S_ZX_Fang8iFy1YMxgEQYmT9omrIo0qTpXy371S4uAPK8KGB4-8N1TeKR-4AEJdjQQASd9ry1G_I_xy9wV5klMCitHQPmHnglClnCK5RJ4BsNh_fjI7L3lTJSxNk31hD3hCpHT6DfA8vitj9o3wtzF2kEba-_DNsuup5vVxwtOIXUoxtWtdhu4mNST8xLYEhjHevxpBx5tnCVzVtvofVbqEIHBd0Qs-R',
        studentCount: 25,
        subject: 'Mathematics',
      ),
      const ClassModel(
        id: '2',
        title: 'History 202',
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBGTNtMBdZd29vc_g_lJKl6sErAKhO3PZ_Z7vYrNQnFstP1RHfWS_D2PIXM2vv-cr_hkFX70XwwzPmpkXrvgDb-XO56z9R2C7dw4wfoz5mNynCbdgZE7DbVEeZPpiZckbfDiKnGU4wBblxNLiYe6loCUzk6bGjlxkTFRhAZSgQJVLEh3nxUSJPxXxPg98krRv9z7GULa3DbDLXi-qJ3aDbSmcCSaI5pGxTrKRKzg5BZwqIVZQW8kLSCE_YBiBVMHGSrb1A7SNjufKhB',
        studentCount: 30,
        subject: 'History',
      ),
      const ClassModel(
        id: '3',
        title: 'Science 303',
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBhhBn8oRkJqk7jGmNa5C2D1sMLpKgtUvUjl6Ydoh9Om0F7cv_EtphZw85Qo-Fcvs-NhDKRAyNiOrjMCVVHNt18SuTEJc-v99b3jSPa32bdX_V63LGcdoF-EttOmh2ty3eZOc0u29OKmRQYSDkRO2cAYrb3iqbP2vbBIsYtTzL3y0sV_C5E9yBk6I3JGStxCTfqQ_mn-wyi9zH7_juJ5EqJdY4V4qC9vMZdu3hG9k2y8xMF5z00HLRfHhTa1LUnPKMcfMGJQnF6WyUM',
        studentCount: 28,
        subject: 'Science',
      ),
    ];
  }

  @override
  Future<List<AssignmentModel>> getAssignments() async {
    // Mock data - replace with actual API call
    await Future.delayed(const Duration(seconds: 1));
    
    return [
      AssignmentModel(
        id: '1',
        title: 'Essay on World War II',
        subtitle: 'Due in 2 days',
        dueDate: DateTime.now().add(const Duration(days: 2)),
        status: 'pending',
      ),
      AssignmentModel(
        id: '2',
        title: 'Math Quiz',
        subtitle: 'Due in 5 days',
        dueDate: DateTime.now().add(const Duration(days: 5)),
        status: 'pending',
      ),
    ];
  }

  @override
  Future<List<NotificationModel>> getNotifications() async {
    // Mock data - replace with actual API call
    await Future.delayed(const Duration(seconds: 1));
    
    return [
      NotificationModel(
        id: '1',
        title: 'New student joined Math 101',
        subtitle: '10:00 AM',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: false,
      ),
      NotificationModel(
        id: '2',
        title: 'Assignment submitted for Math 101',
        subtitle: 'Yesterday',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
      ),
    ];
  }

  @override
  Future<void> markNotificationAsRead(String notificationId) async {
    // Mock implementation - replace with actual API call
    await Future.delayed(const Duration(milliseconds: 500));
  }
} 