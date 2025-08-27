import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';
import '../repositories/home_repository.dart';
import '../entities/home_stats_entity.dart';

class GetHomeStatsUseCase {
  final HomeRepository repository;

  GetHomeStatsUseCase(this.repository);

  Future<Either<Failure, HomeStatsEntity>> call() async {
    return await repository.getHomeStats();
  }
}
