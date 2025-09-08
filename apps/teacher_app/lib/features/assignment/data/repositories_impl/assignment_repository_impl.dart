import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';

import '../../domain/repositories/assignment_repository.dart';
import '../../domain/entities/assignment.dart';
import '../data_sources/remote/assignment_remote_data_source.dart';

class AssignmentRepositoryImpl implements AssignmentRepository {
  final AssignmentRemoteDataSource remoteDataSource;
  AssignmentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure,List<Assignment>>> getAssignments({String? searchQuery, AssignmentStatus? filter}) async {
    final models = await remoteDataSource.getAssignments(searchQuery: searchQuery, filter: filter);
    return models.fold(
      (failure) => Left(failure),
      (assignmentList) {
        return Right(assignmentList.map((m) => m.toEntity()).toList());
      },
    );
  }
} 