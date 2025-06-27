part of 'homework_bloc.dart';

@immutable
sealed class HomeworkState {}

final class HomeworkInitial extends HomeworkState {}

final class HomeworkLoading extends HomeworkState {}

final class HomeworkLoaded extends HomeworkState {
  final List<HomeworkEntity> homeworkList;
  HomeworkLoaded({required this.homeworkList});
}
final class HomeworkFailure extends HomeworkState {
  final String message;
  HomeworkFailure({required this.message});
}

