part of 'question_bloc.dart';

@immutable
sealed class QuestionState {}

final class QuestionInitial extends QuestionState {}

final class QuestionLoadingState extends QuestionState {}

final class GetListQuestionLoadedState extends QuestionState {
  final List<QuestionEntity> questionList;

  GetListQuestionLoadedState({required this.questionList});
}

final class QuestionFailureState extends QuestionState {
  final String message;

  QuestionFailureState({required this.message});
}
