import '../entities/class_entity.dart';
import '../repositories/home_repository.dart';

class GetClassesUseCase {
  final HomeRepository repository;

  GetClassesUseCase(this.repository);

  Future<List<ClassEntity>> call() async {
    return await repository.getClasses();
  }
} 