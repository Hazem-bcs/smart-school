import '../entities/new_assignment_entity.dart';

abstract class NewAssignmentRepository {
  Future<void> addNewAssignment(NewAssignmentEntity assignment);
  Future<List<String>> getClasses();
} 