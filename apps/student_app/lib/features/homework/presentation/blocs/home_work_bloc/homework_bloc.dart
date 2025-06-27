import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homework/domain/entites/homework_entity.dart';
import 'package:homework/domain/usecases/get_homework_use_case.dart';


part 'homework_event.dart';
part 'homework_state.dart';

class HomeworkBloc extends Bloc<HomeworkEvent, HomeworkState> {
  final GetHomeworkUseCase getHomework;

  HomeworkBloc({required this.getHomework}) : super(HomeworkInitial()) {
    on<GetHomeworksEvent>(_onGetHomeworks);
  }

  Future<void> _onGetHomeworks(GetHomeworksEvent event, Emitter<HomeworkState> emit) async {
    emit(HomeworkLoading());
    final result = await getHomework();
    result.fold(
          (failure) {
        emit(HomeworkFailure(message: 'Failed to load homework.'));
      },
          (homeworkList) {
        emit(HomeworkLoaded(homeworkList: homeworkList));
      },
    );
  }
}