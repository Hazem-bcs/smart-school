part of 'teacher_list_bloc.dart';

@immutable
sealed class TeacherListState {}

class TeacherListInitial extends TeacherListState {}
class TeacherListLoading extends TeacherListState {}
class TeacherListLoaded extends TeacherListState {
  final List<TeacherEntity> teacherList;
  TeacherListLoaded({required this.teacherList});
}
class TeacherListError extends TeacherListState {
  final String message;
  TeacherListError({required this.message});
} 