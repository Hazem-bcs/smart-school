import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';
import '../entities/new_assignment_entity.dart';
import '../repositories/new_assignment_repository.dart';

class AddNewAssignmentUseCase {
  final NewAssignmentRepository repository;
  AddNewAssignmentUseCase(this.repository);

  Future<Either<Failure, Unit>> call(NewAssignmentEntity assignment) async {
    return await repository.addNewAssignment(assignment);
  }
} 