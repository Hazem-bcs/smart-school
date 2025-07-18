import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';

import '../dues_repository.dart';
import '../entities/due_entity.dart';

// حالة الاستخدام الوحيدة هي جلب المستحقات
class GetMyDuesUseCase {
  final DuesRepository repository;

  GetMyDuesUseCase(this.repository);

  Future<Either<Failure, List<DueEntity>>> call() async {
    return await repository.getMyDues();
  }
}