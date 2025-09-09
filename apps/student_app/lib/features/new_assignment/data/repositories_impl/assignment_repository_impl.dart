import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';
import '../../domain/repositories/assignment_repository.dart';
import '../../domain/entities/assignment_entity.dart';
import '../data_sources/assignment_remote_data_source.dart';

class AssignmentRepositoryImpl implements AssignmentRepository {
  final AssignmentRemoteDataSource remoteDataSource;

  AssignmentRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<AssignmentEntity>>> getAssignments(String classId) async {
    final result = await remoteDataSource.getAssignments(classId);
    return result.map((models) => models.map((m) => m as AssignmentEntity).toList());
  }

  @override
  Future<Either<Failure, Unit>> submitAssignment({
    required String assignmentId,
    required String studentId,
    required String answerText,
    String? imagePath,
  }) async {
    return remoteDataSource.submitAssignment(
      assignmentId: assignmentId,
      studentId: studentId,
      answerText: answerText,
      imageFile: imagePath == null ? null : File(imagePath),
    );
  }
}