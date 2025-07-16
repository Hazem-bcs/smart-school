import '../models/new_assignment_model.dart';

abstract class NewAssignmentRemoteDataSource {
  Future<void> addNewAssignment(NewAssignmentModel assignment);
  Future<List<String>> getClasses(int teacherId);
}

class NewAssignmentRemoteDataSourceImpl implements NewAssignmentRemoteDataSource {
  // final DioClient dioClient;
  // NewAssignmentRemoteDataSourceImpl(this.dioClient);

  @override
  Future<void> addNewAssignment(NewAssignmentModel assignment) async {
    // TODO: استخدم dioClient.post(...) لإرسال البيانات
    // await dioClient.post('/assignments', data: assignment.toJson());
    print('we added assignmet $assignment');
    await Future.delayed(const Duration(seconds: 1)); // Mock
  }

  @override
  Future<List<String>> getClasses(int teacherId) async {
    // TODO: ربط مع API لاحقاً
    await Future.delayed(const Duration(milliseconds: 500));
    // بيانات افتراضية
    return [
      'Math sec 1',
      'Math sec 2',
      'Math sec 3',
    ];
  }
} 