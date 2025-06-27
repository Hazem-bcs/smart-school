import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';

import 'teacher_entity.dart';

abstract class TeacherRepository {
    Future<Either<Failure,List<TeacherEntity>>> getTeacherList();

  Future<Either<Failure,TeacherEntity>> getTeacherById(int teacherId);
}