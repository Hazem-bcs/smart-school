part of 'homework_bloc.dart';

@immutable
sealed class HomeworkEvent {}

// Renamed for clarity
class GetHomeworksEvent extends HomeworkEvent {}

// New event to handle status updates
class UpdateHomeworkStatusEvent extends HomeworkEvent {
  final String homeworkId;
  final String newStatus;

  UpdateHomeworkStatusEvent({required this.homeworkId, required this.newStatus});
}