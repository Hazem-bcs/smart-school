import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';
import 'package:teacher_app/features/new_assignment/domain/repositories/new_assignment_repository.dart';


class GetClassesUseCase {
  final NewAssignmentRepository repository;

  GetClassesUseCase(this.repository);

  Future<Either<Failure, List<String>>> call() async {
    return await repository.getClasses();
  }
} 