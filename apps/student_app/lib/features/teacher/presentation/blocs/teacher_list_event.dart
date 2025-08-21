part of 'teacher_list_bloc.dart';

@immutable
sealed class TeacherListEvent {}

class GetTeacherList extends TeacherListEvent {
  GetTeacherList();
} 