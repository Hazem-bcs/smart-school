part of 'teacher_details_bloc.dart';

@immutable
sealed class TeacherDetailsEvent {}

class GetTeacherById extends TeacherDetailsEvent {
  final int teacherId;
  GetTeacherById({required this.teacherId});
} 