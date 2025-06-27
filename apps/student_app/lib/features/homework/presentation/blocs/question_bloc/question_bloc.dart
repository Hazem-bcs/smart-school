import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:homework/domain/entites/question_entity.dart';
import 'package:homework/domain/usecases/get_question_list_use_case.dart';
import 'package:homework/domain/usecases/submit_homework_usecase.dart';
part 'question_event.dart';
part 'question_state.dart';

class QuestionBloc extends Bloc<QuestionEvent, QuestionState> {
  final GetQuestionListUseCase getQuestionListUseCase;
  final SubmitHomeworkUseCase submitHomeworkUseCase;
  QuestionBloc({required this.getQuestionListUseCase,required this.submitHomeworkUseCase}) : super(QuestionInitial()) {
    on<GetListQuestionEvent>(_onGetListQuestionEvent);
    on<SubmitHomeworkEvent>(_onSubmitHomeworkEvent);
  }

  Future<void> _onGetListQuestionEvent(GetListQuestionEvent event , Emitter<QuestionState> emit) async {
    emit(QuestionLoadingState());
    final result = await getQuestionListUseCase(event.homeWorkId);
    result.fold(
          (failure) {
        emit(QuestionFailureState(message: 'Failed to load homework.'));
      },
          (questionList) {
        emit(GetListQuestionLoadedState(questionList: questionList));
      },
    );
  }

  Future<void> _onSubmitHomeworkEvent(SubmitHomeworkEvent event , Emitter<QuestionState> emit) async {
    await submitHomeworkUseCase(event.homeWorkId,event.mark);
  }

}
