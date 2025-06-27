part of 'teacher_bloc.dart';

@immutable
sealed class TeacherState {}

final class TeacherInitial extends TeacherState {}

final class GetDataLoadingState extends TeacherState {}

final class TeacherListLoadedState extends TeacherState {
  final List<TeacherEntity> teacherList;

  TeacherListLoadedState({required this.teacherList});
}

final class TeacherByIdLoadedState extends TeacherState {
  final TeacherEntity teacher;

  TeacherByIdLoadedState({required this.teacher});
}

final class ErrorState extends TeacherState {
  final String message;

  ErrorState({required this.message});
}