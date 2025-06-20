import 'package:dartz/dartz.dart';
import 'package:smart_school/core/network/failures.dart';
import 'package:smart_school/features/teacher/domain/teacher_entity.dart';

abstract class TeacherRepository {
    Future<Either<Failure,List<TeacherEntity>>> getTeacherList();

  Future<Either<Failure,TeacherEntity>> getTeacherById(int teacherId);
}