import 'package:flutter_bloc/flutter_bloc.dart';
import 'assignment_event.dart';
import 'assignment_state.dart';
import '../../domain/usecases/get_assignments_usecase.dart';
import '../../domain/usecases/add_assignment_usecase.dart';

class AssignmentBloc extends Bloc<AssignmentEvent, AssignmentState> {
  final GetAssignmentsUseCase getAssignmentsUseCase;
  final AddAssignmentUseCase addAssignmentUseCase;
  AssignmentBloc({required this.getAssignmentsUseCase, required this.addAssignmentUseCase}) : super(AssignmentInitial()) {
    on<LoadAssignments>(_onLoadAssignments);
    on<AddAssignment>(_onAddAssignment);
  }

  Future<void> _onLoadAssignments(
    LoadAssignments event,
    Emitter<AssignmentState> emit,
  ) async {
    emit(AssignmentLoading());
    try {
      final assignments = await getAssignmentsUseCase(
        searchQuery: event.searchQuery,
        filter: event.filter,
      );
      emit(AssignmentLoaded(assignments, searchQuery: event.searchQuery, filter: event.filter));
    } catch (e) {
      emit(AssignmentError(e.toString()));
    }
  }

  Future<void> _onAddAssignment(
    AddAssignment event,
    Emitter<AssignmentState> emit,
  ) async {
    try {
      await addAssignmentUseCase(event.assignment);
      add(const LoadAssignments());
    } catch (e) {
      emit(AssignmentError(e.toString()));
    }
  }
} 