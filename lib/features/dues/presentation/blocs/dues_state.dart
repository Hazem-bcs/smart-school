part of 'dues_bloc.dart';

@immutable
sealed class DuesState {}

final class DuesInitial extends DuesState {}

final class DuesDataLoadingState extends DuesState {}

final class DuesDataLoadedState extends DuesState {
  final List<DueEntity> dueList;

  DuesDataLoadedState({required this.dueList});
}

final class DuesErrorState extends DuesState {
  final String message;

  DuesErrorState({required this.message});
}


