import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';

import 'entities/due_entity.dart';



// العقد الآن أبسط بكثير
abstract class DuesRepository {
  // دالة واحدة فقط لجلب مستحقات الطالب
  Future<Either<Failure, List<DueEntity>>> getMyDues();
}