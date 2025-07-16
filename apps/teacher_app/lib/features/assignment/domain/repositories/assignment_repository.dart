import '../entities/assignment.dart';

abstract class AssignmentRepository {
  Future<List<Assignment>> getAssignments({String? searchQuery, AssignmentStatus? filter});
  Future<void> addAssignment(Assignment assignment);} 