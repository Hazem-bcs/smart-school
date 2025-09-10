import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/submit_grade_usecase.dart';
import 'submission_event.dart';
import 'submission_state.dart';
import '../../domain/usecases/get_student_submissions_usecase.dart';
import '../../domain/entities/student_submission.dart';
import '../../domain/usecases/mark_assignment_as_graded_usecase.dart';

class SubmissionBloc extends Bloc<SubmissionEvent, SubmissionState> {
  final GetStudentSubmissionsUseCase getStudentSubmissionsUseCase;
  final SubmitGradeUseCase submitGradeUseCase;
  final MarkAssignmentAsGradedUseCase markAssignmentAsGradedUseCase;

  List<StudentSubmission> _students = [];
  int _currentStudentIndex = 0;
  String? _currentAssignmentId;

  SubmissionBloc({required this.getStudentSubmissionsUseCase,required this.submitGradeUseCase,required this.markAssignmentAsGradedUseCase}) : super(SubmissionIdle()) {
    on<LoadSubmissionData>(_onLoadSubmissionData);
    on<SubmitGrade>(_onSubmitGrade);
    on<NavigateToNextStudent>(_onNavigateToNextStudent);
    on<NavigateToPreviousStudent>(_onNavigateToPreviousStudent);
    on<NavigateToStudent>(_onNavigateToStudent);
    on<RefreshSubmissionData>(_onRefreshSubmissionData);
    on<MarkAssignmentAsGraded>(_onMarkAssignmentAsGraded);
  }

  Future<void> _onLoadSubmissionData(
    LoadSubmissionData event,
    Emitter<SubmissionState> emit,
  ) async {
    emit(SubmissionLoading());
    _currentAssignmentId = event.assignmentId;
    
    final result = await getStudentSubmissionsUseCase(event.assignmentId);
    result.fold(
      (failure) {
        // في حالة فشل تحميل البيانات، نعرض خطأ مع إمكانية إعادة المحاولة
        emit(SubmissionLoadError(failure.message, event.assignmentId));
      },
      (students) {
        _students = students;
        _currentStudentIndex = 0;
        emit(SubmissionDataLoaded(
          students: _students,
          currentStudentIndex: _currentStudentIndex,
          hasNextStudent: _students.length > 1,
          hasPreviousStudent: false,
        ));
      },
    );
  }

  Future<void> _onSubmitGrade(
    SubmitGrade event,
    Emitter<SubmissionState> emit,
  ) async {
    // حفظ الحالة الحالية قبل التحميل
    final currentStudents = List<StudentSubmission>.from(_students);
    final currentIndex = _currentStudentIndex;
    final hasNext = _currentStudentIndex < _students.length - 1;
    final hasPrevious = _currentStudentIndex > 0;
    
    emit(SubmissionLoading());
    
    final result = await submitGradeUseCase(event.submissionId, event.grade, event.feedback);
    result.fold(
      (failure) {
        // في حالة فشل التصحيح، نعود للحالة الأصلية مع رسالة الخطأ
        emit(GradeSubmissionError(
          message: failure.message,
          submissionId: event.submissionId,
          grade: event.grade,
          feedback: event.feedback,
          students: currentStudents,
          currentStudentIndex: currentIndex,
          hasNextStudent: hasNext,
          hasPreviousStudent: hasPrevious,
        ));
      },
      (success) {
        if (success == true) {
          // تحديث الطالب الحالي فقط في القائمة
          _students[_currentStudentIndex] = _students[_currentStudentIndex].copyWith(
            grade: event.grade,
            feedback: event.feedback,
            isGraded: true,
          );
          emit(SubmissionSuccess(message: 'تم حفظ التصحيح بنجاح'));
          emit(SubmissionDataLoaded(
            students: _students,
            currentStudentIndex: _currentStudentIndex,
            hasNextStudent: _currentStudentIndex < _students.length - 1,
            hasPreviousStudent: _currentStudentIndex > 0,
          ));
        } else {
          // في حالة فشل التصحيح، نعود للحالة الأصلية
          emit(GradeSubmissionError(
            message: 'لم يتم حفظ التصحيح. حاول مجددًا.',
            submissionId: event.submissionId,
            grade: event.grade,
            feedback: event.feedback,
            students: currentStudents,
            currentStudentIndex: currentIndex,
            hasNextStudent: hasNext,
            hasPreviousStudent: hasPrevious,
          ));
        }
      },
    );
  }

  void _onNavigateToNextStudent(
    NavigateToNextStudent event,
    Emitter<SubmissionState> emit,
  ) {
    if (_currentStudentIndex < _students.length - 1) {
      _currentStudentIndex++;
      emit(SubmissionDataLoaded(
        students: _students,
        currentStudentIndex: _currentStudentIndex,
        hasNextStudent: _currentStudentIndex < _students.length - 1,
        hasPreviousStudent: _currentStudentIndex > 0,
      ));
    }
  }

  void _onNavigateToPreviousStudent(
    NavigateToPreviousStudent event,
    Emitter<SubmissionState> emit,
  ) {
    if (_currentStudentIndex > 0) {
      _currentStudentIndex--;
      emit(SubmissionDataLoaded(
        students: _students,
        currentStudentIndex: _currentStudentIndex,
        hasNextStudent: _currentStudentIndex < _students.length - 1,
        hasPreviousStudent: _currentStudentIndex > 0,
      ));
    }
  }

  void _onNavigateToStudent(
    NavigateToStudent event,
    Emitter<SubmissionState> emit,
  ) {
    if (event.studentIndex >= 0 && event.studentIndex < _students.length) {
      _currentStudentIndex = event.studentIndex;
      emit(SubmissionDataLoaded(
        students: _students,
        currentStudentIndex: _currentStudentIndex,
        hasNextStudent: _currentStudentIndex < _students.length - 1,
        hasPreviousStudent: _currentStudentIndex > 0,
      ));
    }
  }

  Future<void> _onRefreshSubmissionData(
    RefreshSubmissionData event,
    Emitter<SubmissionState> emit,
  ) async {
    if (_currentAssignmentId != null) {
      add(LoadSubmissionData(_currentAssignmentId!));
    }
  }

  Future<void> _onMarkAssignmentAsGraded(
    MarkAssignmentAsGraded event,
    Emitter<SubmissionState> emit,
  ) async {
    // حفظ الحالة الحالية قبل التحميل
    final currentStudents = List<StudentSubmission>.from(_students);
    final currentIndex = _currentStudentIndex;
    final hasNext = _currentStudentIndex < _students.length - 1;
    final hasPrevious = _currentStudentIndex > 0;
    
    emit(SubmissionLoading());
    
    final result = await markAssignmentAsGradedUseCase(event.assignmentId);
    result.fold(
      (failure) {
        // في حالة فشل وضع الواجب كمصحح، نعود للحالة الأصلية مع رسالة الخطأ
        emit(MarkAsGradedError(
          message: failure.message,
          assignmentId: event.assignmentId,
          students: currentStudents,
          currentStudentIndex: currentIndex,
          hasNextStudent: hasNext,
          hasPreviousStudent: hasPrevious,
        ));
      },
      (success) {
        if (success == true) {
          emit(SubmissionSuccess(message: 'تم وضع الواجب كمصحح بنجاح'));
        } else {
          // في حالة فشل وضع الواجب كمصحح، نعود للحالة الأصلية
          emit(MarkAsGradedError(
            message: 'لم يتم وضع الواجب كمصحح. حاول مجددًا.',
            assignmentId: event.assignmentId,
            students: currentStudents,
            currentStudentIndex: currentIndex,
            hasNextStudent: hasNext,
            hasPreviousStudent: hasPrevious,
          ));
        }
      },
    );
  }
}

extension StudentSubmissionExtension on StudentSubmission {
  StudentSubmission copyWith({
    String? id,
    String? studentName,
    String? response,
    List<String>? images,
    String? grade,
    String? feedback,
    DateTime? submittedAt,
    bool? isGraded,
  }) {
    return StudentSubmission(
      id: id ?? this.id,
      studentName: studentName ?? this.studentName,
      response: response ?? this.response,
      images: images ?? this.images,
      grade: grade ?? this.grade,
      feedback: feedback ?? this.feedback,
      submittedAt: submittedAt ?? this.submittedAt,
      isGraded: isGraded ?? this.isGraded,
    );
  }
} 