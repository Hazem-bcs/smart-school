part of 'homework_bloc.dart';

@immutable
sealed class HomeworkEvent {}

// Renamed for clarity
class GetHomeworksEvent extends HomeworkEvent {}