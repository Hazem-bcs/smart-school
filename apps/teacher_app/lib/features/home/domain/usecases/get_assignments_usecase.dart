import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';
import '../entities/assignment_entity.dart';
import '../repositories/home_repository.dart';

class GetAssignmentsUseCase {
  final HomeRepository repository;

  GetAssignmentsUseCase(this.repository);

  Future<Either<Failure, List<AssignmentEntity>>> call() async => repository.getAssignments();
} 