import '../repositories/assignment_repository.dart';
import '../entities/assignment.dart';

class AddAssignmentUseCase {
  final AssignmentRepository repository;
  AddAssignmentUseCase(this.repository);

  Future<void> call(Assignment assignment) {
    return repository.addAssignment(assignment);
  }
} 