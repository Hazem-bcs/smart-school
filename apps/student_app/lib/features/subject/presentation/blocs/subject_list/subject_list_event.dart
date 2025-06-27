part of 'subject_list_bloc.dart';

@immutable
sealed class SubjectListEvent {}

class GetSubjectListEvent extends SubjectListEvent {}