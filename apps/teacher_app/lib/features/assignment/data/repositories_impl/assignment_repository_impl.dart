import '../../domain/repositories/assignment_repository.dart';
import '../../domain/entities/assignment.dart';
import '../data_sources/remote/assignment_remote_data_source.dart';
import '../models/assignment_model.dart';

class AssignmentRepositoryImpl implements AssignmentRepository {
  final AssignmentRemoteDataSource remoteDataSource;
  AssignmentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Assignment>> getAssignments({String? searchQuery, AssignmentStatus? filter}) async {
    final models = await remoteDataSource.getAssignments(searchQuery: searchQuery, filter: filter);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> addAssignment(Assignment assignment) async {
    final model = AssignmentModel.fromEntity(assignment);
    await remoteDataSource.addAssignment(model);
  }
} 