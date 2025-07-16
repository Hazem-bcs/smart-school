import '../entities/class_entity.dart';
import '../repositories/home_repository.dart';

class GetHomeClassesUseCase {
  final HomeRepository repository;

  GetHomeClassesUseCase(this.repository);

  Future<List<ClassEntity>> call() async {
    return await repository.getClasses();
  }
} 