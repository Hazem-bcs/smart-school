import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/submit_grade_usecase.dart';
import 'submission_event.dart';
import 'submission_state.dart';

class SubmissionBloc extends Bloc<SubmissionEvent, SubmissionState> {
  final SubmitGradeUseCase? submitGradeUseCase;
  
  // Mock data for demonstration
  List<StudentSubmission> _students = [];
  int _currentStudentIndex = 0;

  SubmissionBloc({this.submitGradeUseCase}) : super(SubmissionIdle()) {
    on<LoadSubmissionData>(_onLoadSubmissionData);
    on<SubmitGrade>(_onSubmitGrade);
    on<NavigateToNextStudent>(_onNavigateToNextStudent);
    on<NavigateToPreviousStudent>(_onNavigateToPreviousStudent);
    on<NavigateToStudent>(_onNavigateToStudent);
    on<RefreshSubmissionData>(_onRefreshSubmissionData);
  }

  Future<void> _onLoadSubmissionData(
    LoadSubmissionData event,
    Emitter<SubmissionState> emit,
  ) async {
    emit(SubmissionLoading());
    
    try {
      // Mock data - replace with actual API call
      await Future.delayed(const Duration(seconds: 1));
      
      _students = [
        StudentSubmission(
          id: '1',
          studentName: 'Olivia Bennett',
          response: 'The central theme of the novel revolves around the quest for identity and belonging in a society undergoing rapid transformation. The protagonist, Chloe, navigates her cultural background and her desire to integrate with her peers. This inner conflict fuels the narrative and shapes Chloe\'s journey of self-discovery.',
          images: [
            'https://lh3.googleusercontent.com/aida-public/AB6AXuAaD4QFtFzumfJTmc8dZpX1E7ZZiiBy3S5RfyW2xHt_-VV6nri7AOQd9XFpgiwJMjjvV8lOzxpPcYHyERfdNYqSP4fkl2DpPj9wBy-QpMG1RR7TUkpqnG5MJ5Usnpg4lR6XKvB4BeLjex76QC8bq9YT6UhrSQCso448YWNJBbmmaJ9lU-1nFgAls9DruO3Z4jN8oyj3doObNi8yU2e-p9RmE92Dtm6CEs1450za3Ywi94F0FM9qI_LAp0lPzxY1p5QRi-mofQDfPY8_',
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCoFqAIUnZ6twyCprcHwJmS_c3n3n1GVnwUzD1m1M10oqOLcUwq5dn9kaLLVobOLZKVafUk6baUC4a1KHKZCftsDjqByn1GKT3vgZjKVO-6lo9ygxv5zkXnfYh_8pt40hsqsnPL8JFtxcI6Ya4rfMhXswLMtVTYzk7VkPPFXOItOEx3hr8ewlHQ1Dbx8W2btlaZW4tyqmOCUxk6tw8k3Mf-LYI8bl64A_ii_tckmnZGR_NYrnumnYF6KtzGYsOIQrSLgQ9-I3NZCH20'
          ],
          submittedAt: DateTime.now().subtract(const Duration(days: 2)),
          isGraded: false,
        ),
        StudentSubmission(
          id: '2',
          studentName: 'Emma Wilson',
          response: 'The novel explores themes of cultural identity and social integration through the lens of a young protagonist navigating complex societal expectations. The narrative delves into the challenges of maintaining one\'s heritage while seeking acceptance in a rapidly changing world.',
          images: [
            'https://lh3.googleusercontent.com/aida-public/AB6AXuAaD4QFtFzumfJTmc8dZpX1E7ZZiiBy3S5RfyW2xHt_-VV6nri7AOQd9XFpgiwJMjjvV8lOzxpPcYHyERfdNYqSP4fkl2DpPj9wBy-QpMG1RR7TUkpqnG5MJ5Usnpg4lR6XKvB4BeLjex76QC8bq9YT6UhrSQCso448YWNJBbmmaJ9lU-1nFgAls9DruO3Z4jN8oyj3doObNi8yU2e-p9RmE92Dtm6CEs1450za3Ywi94F0FM9qI_LAp0lPzxY1p5QRi-mofQDfPY8_'
          ],
          submittedAt: DateTime.now().subtract(const Duration(days: 1)),
          isGraded: true,
          grade: '85',
          feedback: 'Excellent analysis of cultural themes. Well-structured response.',
        ),
        StudentSubmission(
          id: '3',
          studentName: 'James Rodriguez',
          response: 'The story presents a compelling exploration of identity formation in multicultural societies. The protagonist\'s journey reflects the universal struggle of finding one\'s place in the world while honoring cultural roots.',
          images: [],
          submittedAt: DateTime.now().subtract(const Duration(hours: 6)),
          isGraded: false,
        ),
      ];
      
      _currentStudentIndex = 0;
      
      emit(SubmissionDataLoaded(
        students: _students,
        currentStudentIndex: _currentStudentIndex,
        hasNextStudent: _students.length > 1,
        hasPreviousStudent: false,
      ));
    } catch (e) {
      emit(SubmissionError('Failed to load submission data: $e'));
    }
  }

  Future<void> _onSubmitGrade(
    SubmitGrade event,
    Emitter<SubmissionState> emit,
  ) async {
    emit(SubmissionLoading());
    
    try {
      if (submitGradeUseCase != null) {
        await submitGradeUseCase!(event.submissionId, event.grade, event.feedback);
      } else {
        // Mock implementation
        await Future.delayed(const Duration(seconds: 2));
        
        // Update local data
        if (_currentStudentIndex < _students.length) {
          _students[_currentStudentIndex] = _students[_currentStudentIndex].copyWith(
            grade: event.grade,
            feedback: event.feedback,
            isGraded: true,
          );
        }
      }
      
      emit(SubmissionSuccess());
      
      // Reload data to show updated state
      await Future.delayed(const Duration(seconds: 1));
      emit(SubmissionDataLoaded(
        students: _students,
        currentStudentIndex: _currentStudentIndex,
        hasNextStudent: _currentStudentIndex < _students.length - 1,
        hasPreviousStudent: _currentStudentIndex > 0,
      ));
    } catch (e) {
      emit(SubmissionError('Failed to submit grade: $e'));
    }
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
    if (_students.isNotEmpty) {
      add(LoadSubmissionData(_students.first.id));
    }
  }
}

// Extension to create copy of StudentSubmission
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