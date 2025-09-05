import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';
import '../entities/class_entity.dart';
import '../repositories/home_repository.dart';

class GetHomeClassesUseCase {
  final HomeRepository repository;

  GetHomeClassesUseCase(this.repository);

  Future<Either<Failure, List<ClassEntity>>> call() async => repository.getClasses();
} 