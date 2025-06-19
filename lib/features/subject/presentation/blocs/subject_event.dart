part of 'subject_bloc.dart';

@immutable
sealed class SubjectEvent {}

class GetSubjectEvent extends SubjectEvent {
  final int id;

  GetSubjectEvent({required this.id});
}