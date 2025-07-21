
import '../repositories/new_assignment_repository.dart';


class GetClassesUseCase {
  final NewAssignmentRepository repository;

  GetClassesUseCase(this.repository);

  Future<List<String>> call() async {
    return await repository.getClasses();
  }
} 