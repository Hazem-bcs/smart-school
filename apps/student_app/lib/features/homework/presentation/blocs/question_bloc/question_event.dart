part of 'question_bloc.dart';

@immutable
sealed class QuestionEvent {}

class GetListQuestionEvent extends QuestionEvent {
  final int homeWorkId;

  GetListQuestionEvent({required this.homeWorkId});
}

class SubmitHomeworkEvent extends QuestionEvent {
  final int homeWorkId;
  final int mark;

  SubmitHomeworkEvent({required this.homeWorkId,required this.mark});
}