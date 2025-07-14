import 'package:flutter_bloc/flutter_bloc.dart';
import 'assignment_event.dart';
import 'assignment_state.dart';
import '../../domain/models/assignment.dart';

class AssignmentBloc extends Bloc<AssignmentEvent, AssignmentState> {
  AssignmentBloc() : super(AssignmentInitial()) {
    on<LoadAssignments>(_onLoadAssignments);
    on<AddAssignment>(_onAddAssignment);
  }

  // Sample data (replace with repository/API in real app)
  final List<Assignment> _allAssignments = [
    Assignment(
      id: '1',
      title: 'Math Quiz 1',
      subtitle: 'Due: Oct 26 · 25/25 submitted',
      isCompleted: true,
      dueDate: DateTime(2024, 10, 26),
      submittedCount: 25,
      totalCount: 25,
      status: AssignmentStatus.graded,
    ),
    Assignment(
      id: '2',
      title: 'Science Project',
      subtitle: 'Due: Oct 27 · 20/25 submitted',
      isCompleted: false,
      dueDate: DateTime(2024, 10, 27),
      submittedCount: 20,
      totalCount: 25,
      status: AssignmentStatus.ungraded,
    ),
    Assignment(
      id: '3',
      title: 'English Essay',
      subtitle: 'Due: Oct 28 · 25/25 submitted',
      isCompleted: true,
      dueDate: DateTime(2024, 10, 28),
      submittedCount: 25,
      totalCount: 25,
      status: AssignmentStatus.graded,
    ),
    Assignment(
      id: '4',
      title: 'History Report',
      subtitle: 'Due: Oct 29 · 22/25 submitted',
      isCompleted: false,
      dueDate: DateTime(2024, 10, 29),
      submittedCount: 22,
      totalCount: 25,
      status: AssignmentStatus.ungraded,
    ),
    Assignment(
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

  Future<void> _onLoadAssignments(
    LoadAssignments event,
    Emitter<AssignmentState> emit,
  ) async {
    emit(AssignmentLoading());
    await Future.delayed(const Duration(milliseconds: 500));
    List<Assignment> filtered = _allAssignments;
    if (event.searchQuery != null && event.searchQuery!.isNotEmpty) {
      filtered = filtered.where((a) =>
        a.title.toLowerCase().contains(event.searchQuery!.toLowerCase()) ||
        a.subtitle.toLowerCase().contains(event.searchQuery!.toLowerCase())
      ).toList();
    }
    if (event.filter != null && event.filter != AssignmentStatus.all) {
      filtered = filtered.where((a) => a.status == event.filter).toList();
    }
    emit(AssignmentLoaded(filtered, searchQuery: event.searchQuery, filter: event.filter));
  }

  Future<void> _onAddAssignment(
    AddAssignment event,
    Emitter<AssignmentState> emit,
  ) async {
    _allAssignments.add(event.assignment);
    add(const LoadAssignments());
  }
} 