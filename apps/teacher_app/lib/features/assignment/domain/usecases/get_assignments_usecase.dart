import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';

import '../repositories/assignment_repository.dart';
import '../entities/assignment.dart';

class GetAssignmentsUseCase {
  final AssignmentRepository repository;
  GetAssignmentsUseCase(this.repository);

  Future<Either<Failure,List<Assignment>>> call({String? searchQuery, AssignmentStatus? filter}) {
    return repository.getAssignments(searchQuery: searchQuery, filter: filter);
  }
} 