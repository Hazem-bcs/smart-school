import 'package:teacher_app/features/new_assignment/data/data_sources/newAssignmentLocalDataSource.dart';

import '../../domain/entities/new_assignment_entity.dart';
import '../../domain/repositories/new_assignment_repository.dart';
import '../models/new_assignment_model.dart';
import '../data_sources/new_assignment_remote_data_source.dart';

class NewAssignmentRepositoryImpl implements NewAssignmentRepository {
  final NewAssignmentRemoteDataSource remoteDataSource;
  final NewAssignmentLocalDataSource localDataSource;
  NewAssignmentRepositoryImpl(this.remoteDataSource,this.localDataSource);

  @override
  Future<void> addNewAssignment(NewAssignmentEntity assignment) async {
    final model = NewAssignmentModel(
      title: assignment.title,
      description: assignment.description,
      classId: assignment.classId,
      dueDate: assignment.dueDate,
      points: assignment.points,
    );
    await remoteDataSource.addNewAssignment(model);
  }

  @override
  Future<List<String>> getClasses() async {
    final teacherId = await localDataSource.getId();
    return await remoteDataSource.getClasses(teacherId ?? 0);
  }
} 