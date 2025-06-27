part of 'subject_bloc.dart';

@immutable
sealed class SubjectEvent {}

class GetSubjectDetailsEvent extends SubjectEvent {
  final int id;

  GetSubjectDetailsEvent({required this.id});
}