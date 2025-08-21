import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';

import '../teacher_entity.dart';
import '../teatcher_repository.dart';


class GetTeacherListUseCase {
  final TeacherRepository repository;

  GetTeacherListUseCase(this.repository);

  Future<Either<Failure,List<TeacherEntity>>> call() async {
    return await repository.getTeacherList();
  }
}