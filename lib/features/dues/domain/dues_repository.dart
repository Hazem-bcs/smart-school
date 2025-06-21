import 'package:dartz/dartz.dart';

import '../../../../core/network/failures.dart';
import 'entities/due_entity.dart';

// العقد الآن أبسط بكثير
abstract class DuesRepository {
  // دالة واحدة فقط لجلب مستحقات الطالب
  Future<Either<Failure, List<DueEntity>>> getMyDues();
}