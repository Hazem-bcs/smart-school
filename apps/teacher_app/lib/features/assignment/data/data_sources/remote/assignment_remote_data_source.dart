import '../../models/assignment_model.dart';
import '../../../domain/entities/assignment.dart';

abstract class AssignmentRemoteDataSource {
  Future<List<AssignmentModel>> getAssignments({String? searchQuery, AssignmentStatus? filter});
  Future<void> addAssignment(AssignmentModel assignment);
}

class AssignmentRemoteDataSourceImpl implements AssignmentRemoteDataSource {
  // بيانات وهمية مؤقتة
  final List<AssignmentModel> _allAssignments = [
    AssignmentModel(
      id: '1',
      title: 'Math Quiz 1',
      subtitle: 'Due: Oct 26 · 25/25 submitted',
      isCompleted: true,
      dueDate: DateTime(2024, 10, 26),
      submittedCount: 25,
      totalCount: 25,
      status: AssignmentStatus.graded,
    ),
    AssignmentModel(
      id: '2',
      title: 'Science Project',
      subtitle: 'Due: Oct 27 · 20/25 submitted',
      isCompleted: false,
      dueDate: DateTime(2024, 10, 27),
      submittedCount: 20,
      totalCount: 25,
      status: AssignmentStatus.ungraded,
    ),
    AssignmentModel(
      id: '3',
      title: 'English Essay',
      subtitle: 'Due: Oct 28 · 25/25 submitted',
      isCompleted: true,
      dueDate: DateTime(2024, 10, 28),
      submittedCount: 25,
      totalCount: 25,
      status: AssignmentStatus.graded,
    ),
    AssignmentModel(
      id: '4',
      title: 'History Report',
      subtitle: 'Due: Oct 29 · 22/25 submitted',
      isCompleted: false,
      dueDate: DateTime(2024, 10, 29),
      submittedCount: 22,
      totalCount: 25,
      status: AssignmentStatus.ungraded,
    ),
    AssignmentModel(
      id: '5',
      title: 'Art Portfolio',
      subtitle: 'Due: Oct 30 · 25/25 submitted',
      isCompleted: true,
      dueDate: DateTime(2024, 10, 30),
      submittedCount: 25,
      totalCount: 25,
      status: AssignmentStatus.graded,
    ),
  ];

  @override
  Future<List<AssignmentModel>> getAssignments({String? searchQuery, AssignmentStatus? filter}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    List<AssignmentModel> filtered = _allAssignments;
    if (searchQuery != null && searchQuery.isNotEmpty) {
      filtered = filtered.where((a) =>
        a.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
        a.subtitle.toLowerCase().contains(searchQuery.toLowerCase())
      ).toList();
    }
    if (filter != null && filter != AssignmentStatus.all) {
      filtered = filtered.where((a) => a.status == filter).toList();
    }
    return filtered;
    // TODO: عند الربط مع الـ backend استبدل الكود التالي:
    // final response = await dioClient.get('/assignments');
    // return (response.data as List).map((json) => AssignmentModel.fromJson(json)).toList();
  }

  @override
  Future<void> addAssignment(AssignmentModel assignment) async {
    _allAssignments.add(assignment);
    // TODO: عند الربط مع الـ backend استبدل الكود التالي:
    // await dioClient.post('/assignments', data: assignment.toJson());
  }
} 