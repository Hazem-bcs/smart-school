import 'package:flutter_bloc/flutter_bloc.dart';
import 'assignment_event.dart';
import 'assignment_state.dart';
import '../../domain/usecases/get_assignments_usecase.dart';

class AssignmentBloc extends Bloc<AssignmentEvent, AssignmentState> {
  final GetAssignmentsUseCase getAssignmentsUseCase;
  
  AssignmentBloc({required this.getAssignmentsUseCase}) : super(AssignmentInitial()) {
    on<LoadAssignments>(_onLoadAssignments);
  }

  Future<void> _onLoadAssignments(
    LoadAssignments event,
    Emitter<AssignmentState> emit,
  ) async {
    emit(AssignmentLoading());
    final result = await getAssignmentsUseCase(
      searchQuery: event.searchQuery,
      filter: event.filter,
    );
    result.fold(
      (failure) => emit(AssignmentError(failure.message)),
      (assignments) => emit(
        AssignmentLoaded(
          assignments,
          searchQuery: event.searchQuery,
          filter: event.filter,
        ),
      ),
    );
  }
} 