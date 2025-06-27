import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';

import '../entities/resource_entity.dart';
import '../resource_repositroty.dart';

class GetResourceListUseCase {
  final ResourceRepository repository;

  GetResourceListUseCase(this.repository);

  Future<Either<Failure,List<ResourceEntity>>> call() async {
    return await repository.getResourceList();
  }
}