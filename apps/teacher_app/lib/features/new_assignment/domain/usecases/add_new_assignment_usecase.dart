import '../entities/new_assignment_entity.dart';
import '../repositories/new_assignment_repository.dart';

class AddNewAssignmentUseCase {
  final NewAssignmentRepository repository;
  AddNewAssignmentUseCase(this.repository);

  Future<void> call(NewAssignmentEntity assignment) async {
    await repository.addNewAssignment(assignment);
  }
} 