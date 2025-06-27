import '../homework_repository.dart';

class SubmitHomeworkUseCase {
  final HomeworkRepository repository;

  SubmitHomeworkUseCase(this.repository);

  Future<void> call(int homeworkId, int mark) async {
    return await repository.updateHomeworkStatus(homeworkId,mark);
  }
}