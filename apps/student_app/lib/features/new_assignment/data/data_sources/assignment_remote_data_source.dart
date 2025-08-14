
import '../../domain/entities/assignment_entity.dart';
import '../models/assignment_model.dart';

abstract class AssignmentRemoteDataSource {
  Future<List<AssignmentModel>> getAssignments(String classId);
}

class AssignmentRemoteDataSourceImpl implements AssignmentRemoteDataSource {
  @override
  Future<List<AssignmentModel>> getAssignments(String classId) async {
    await Future.delayed(const Duration(seconds: 1));

    return [
      // 1. مهمة تم تصحيحها (Graded)
      AssignmentModel(
        assignmentId: '1',
        title: 'Math Quiz 1',
        description: 'Solve the first quiz on algebra.',
        classId: 'class_a',
        dueDate: DateTime.now().subtract(const Duration(days: 2)),
        points: 25,
        submissionStatus: SubmissionStatus.graded,
        grade: 22,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        teacherAttachments: [],
      ),
      // 2. مهمة جديدة لم يتم تسليمها (New & Ungraded)
      AssignmentModel(
        assignmentId: '2',
        title: 'Science Project',
        description: 'Build a simple volcano model and present it.',
        classId: 'class_a',
        dueDate: DateTime.now().add(const Duration(days: 7)),
        points: 100,
        submissionStatus: SubmissionStatus.notSubmitted, // حالة "غير مصححة"
        grade: null,
        createdAt: DateTime.now().subtract(const Duration(hours: 1)), // تم إنشاؤها قبل ساعة
        teacherAttachments: ['project_guidelines.pdf'],
      ),
      // 3. مهمة عادية غير مصححة (Ungraded)
      AssignmentModel(
        assignmentId: '3',
        title: 'History Report',
        description: 'Write a 5-page report on the American Revolution.',
        classId: 'class_a',
        dueDate: DateTime.now().add(const Duration(days: 3)),
        points: 50,
        submissionStatus: SubmissionStatus.notSubmitted, // حالة "غير مصححة"
        grade: null,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        teacherAttachments: [],
      ),
      // 4. مهمة فات موعدها وغير مصححة (Ungraded & Late)
      AssignmentModel(
        assignmentId: '4',
        title: 'Art Portfolio',
        description: 'Complete your art portfolio with 10 drawings.',
        classId: 'class_a',
        dueDate: DateTime.now().subtract(const Duration(days: 1)),
        points: 40,
        submissionStatus: SubmissionStatus.notSubmitted, // حالة "غير مصححة"
        grade: null,
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
        teacherAttachments: ['art_examples.jpg', 'portfolio_checklist.docx'],
      ),
    ];
  }
}