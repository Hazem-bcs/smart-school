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
      ),
      // 2. مهمة جديدة لم يتم تسليمها (New & Ungraded)
      AssignmentModel(
        assignmentId: '2',
        title: 'Science Project',
        description: 'Build a simple volcano model and present it.',
        classId: 'class_a',
        dueDate: DateTime.now().add(const Duration(days: 7)),
        points: 100,
        submissionStatus: SubmissionStatus.notSubmitted,
        // حالة "غير مصححة"
        grade: null,
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        // تم إنشاؤها قبل ساعة
      ),
      AssignmentModel(
        assignmentId: '3',
        title: 'Physics Lab Report',
        description:
            'Conduct an experiment on gravity and write a detailed report.',
        classId: 'class_d',
        dueDate: DateTime.now().subtract(const Duration(days: 5)),
        points: 100,
        submissionStatus: SubmissionStatus.graded,
        // حالة تم التصحيح
        grade: 92,
        teacherNote:
            'Excellent work! The analysis section was particularly well-done.',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
      AssignmentModel(
        assignmentId: '2',
        title: 'History Essay',
        description: 'Write an essay on the causes of World War I.',
        classId: 'class_c',
        dueDate: DateTime.now().add(const Duration(hours: 3)),
        points: 75,
        submissionStatus: SubmissionStatus.submitted,
        // حالة تم التسليم
        grade: null,
        teacherNote: null,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        teacherImageAttachment: null,
      ),
      AssignmentModel(
        assignmentId: '1',
        title: 'Math Homework',
        description: 'Solve problems on linear equations from the textbook.',
        classId: 'class_b',
        dueDate: DateTime.now().add(const Duration(days: 2)),
        points: 50,
        submissionStatus: SubmissionStatus.notSubmitted,
        // حالة لم يتم التسليم
        grade: null,
        teacherNote: null,
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        // teacherImageAttachment: 'https://cdn.pixabay.com/photo/2015/07/15/07/20/math-845876_1280.jpg', // ✅ تم إضافة رابط صورة هنا
        teacherImageAttachment: 'assets/images/img.png', // ✅ تم إضافة رابط صورة هنا
      ),
      // 3. مهمة عادية غير مصححة (Ungraded)
      AssignmentModel(
        assignmentId: '3',
        title: 'History Report',
        description: 'Write a 5-page report on the American Revolution.',
        classId: 'class_a',
        dueDate: DateTime.now().add(const Duration(days: 3)),
        points: 50,
        submissionStatus: SubmissionStatus.notSubmitted,
        // حالة "غير مصححة"
        grade: null,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      // 4. مهمة فات موعدها وغير مصححة (Ungraded & Late)
      AssignmentModel(
        assignmentId: '4',
        title: 'Art Portfolio',
        description: 'Complete your art portfolio with 10 drawings.',
        classId: 'class_a',
        dueDate: DateTime.now().subtract(const Duration(days: 1)),
        points: 40,
        submissionStatus: SubmissionStatus.notSubmitted,
        // حالة "غير مصححة"
        grade: null,
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
      ),
    ];
  }
}
