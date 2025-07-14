import '../entities/assignment_entity.dart';
import '../repositories/home_repository.dart';

class GetAssignmentsUseCase {
  final HomeRepository repository;

  GetAssignmentsUseCase(this.repository);

  Future<List<AssignmentEntity>> call() async {
    return await repository.getAssignments();
  }
} 