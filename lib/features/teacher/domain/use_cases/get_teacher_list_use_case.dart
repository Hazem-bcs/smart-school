import 'package:dartz/dartz.dart';
import 'package:smart_school/core/network/failures.dart';

import '../teacher_entity.dart';
import '../teatcher_repository.dart';


class GetTeacherListUseCase {
  final TeacherRepository repository;

  GetTeacherListUseCase({required this.repository});

  Future<Either<Failure,List<TeacherEntity>>> call(int studentId) async {
    return await repository.getTeacherList(studentId);
  }
}