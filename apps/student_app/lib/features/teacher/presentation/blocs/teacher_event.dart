part of 'teacher_bloc.dart';

@immutable
sealed class TeacherEvent {}

class GetTeacherList extends TeacherEvent {
  final int studentId;

  GetTeacherList({required this.studentId});
}

class GetTeacherById extends TeacherEvent {
  final int teacherId;

  GetTeacherById({required this.teacherId});
}
