import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';
import '../entities/new_assignment_entity.dart';

abstract class NewAssignmentRepository {
  Future<Either<Failure, Unit>> addNewAssignment(NewAssignmentEntity assignment);
  Future<Either<Failure, List<String>>> getClasses();
} 