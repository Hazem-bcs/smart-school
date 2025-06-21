part of 'subject_bloc.dart';

@immutable
sealed class SubjectState {}

final class SubjectInitial extends SubjectState {}

final class SubjectLoading extends SubjectState {}

final class SubjectLoaded extends SubjectState {
  final SubjectEntity subjectEntity;
  SubjectLoaded({required this.subjectEntity});
}

final class SubjectFailure extends SubjectState {
  final String message;
  SubjectFailure({required this.message});
}
// // NEW
// final class AllSubjectsLoading extends SubjectState {}
//
// // NEW
// final class AllSubjectsLoaded extends SubjectState {
//   final List<SubjectEntity> subjects;
//   AllSubjectsLoaded({required this.subjects});
// }