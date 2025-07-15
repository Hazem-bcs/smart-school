import '../repositories/assignment_repository.dart';
import '../entities/assignment.dart';

class GetAssignmentsUseCase {
  final AssignmentRepository repository;
  GetAssignmentsUseCase(this.repository);

  Future<List<Assignment>> call({String? searchQuery, AssignmentStatus? filter}) {
    return repository.getAssignments(searchQuery: searchQuery, filter: filter);
  }
} 