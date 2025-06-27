import 'package:core/network/failures.dart';
import 'package:dartz/dartz.dart';

import 'entities/resource_entity.dart';

abstract class ResourceRepository {
  Future<Either<Failure,List<ResourceEntity>>> getResourceList();
}