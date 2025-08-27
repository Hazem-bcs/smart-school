import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';
import '../repositories/home_repository.dart';
import '../entities/quick_action_entity.dart';

class GetQuickActionsUseCase {
  final HomeRepository repository;

  GetQuickActionsUseCase(this.repository);

  Future<Either<Failure, List<QuickActionEntity>>> call() async {
    return await repository.getQuickActions();
  }
}
