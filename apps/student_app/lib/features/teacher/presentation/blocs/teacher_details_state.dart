part of 'teacher_details_bloc.dart';

@immutable
sealed class TeacherDetailsState {}

class TeacherDetailsInitial extends TeacherDetailsState {}
class TeacherDetailsLoading extends TeacherDetailsState {}
class TeacherDetailsLoaded extends TeacherDetailsState {
  final TeacherEntity teacher;
  TeacherDetailsLoaded({required this.teacher});
}
class TeacherDetailsError extends TeacherDetailsState {
  final String message;
  TeacherDetailsError({required this.message});
} 