import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';

import '../entities/assignment.dart';

abstract class AssignmentRepository {
  Future<Either<Failure,List<Assignment>>> getAssignments({String? searchQuery, AssignmentStatus? filter});
} 