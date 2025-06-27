import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';

import '../teacher_entity.dart';
import '../teatcher_repository.dart';



class GetTeacherByIdUseCase {
  final TeacherRepository repository;

  GetTeacherByIdUseCase(this.repository);

  Future<Either<Failure, TeacherEntity>> call(int teacherId) async {
    return await repository.getTeacherById(teacherId);
  }
}