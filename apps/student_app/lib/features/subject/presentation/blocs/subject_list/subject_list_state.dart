part of 'subject_list_bloc.dart';

@immutable
sealed class SubjectListState {}

final class SubjectListInitial extends SubjectListState {}

final class SubjectListLoading extends SubjectListState {}

final class SubjectListLoaded extends SubjectListState {
  final List<SubjectEntity> subjectEntityList;
  SubjectListLoaded({required this.subjectEntityList});
}

final class SubjectListFailure extends SubjectListState {
  final String message;
  SubjectListFailure({required this.message});
}