import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';
import '../repositories/home_repository.dart';
import '../entities/promo_entity.dart';

class GetPromosUseCase {
  final HomeRepository repository;

  GetPromosUseCase(this.repository);

  Future<Either<Failure, List<PromoEntity>>> call() async {
    return await repository.getPromos();
  }
}
