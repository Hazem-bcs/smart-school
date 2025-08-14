import '../../domain/repositories/assignment_repository.dart';
import '../../domain/entities/assignment_entity.dart';
import '../data_sources/assignment_remote_data_source.dart';
import 'package:dartz/dartz.dart';

class AssignmentRepositoryImpl implements AssignmentRepository {
  final AssignmentRemoteDataSource remoteDataSource;

  AssignmentRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Exception, List<AssignmentEntity>>> getAssignments(String classId) async {
    try {
      final assignmentModels = await remoteDataSource.getAssignments(classId);
      return Right(assignmentModels.map((model) => model as AssignmentEntity).toList());
    } catch (e) {
      return Left(Exception('Failed to get assignments'));
    }
  }
}