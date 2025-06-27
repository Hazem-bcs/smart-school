part of 'dues_bloc.dart';

@immutable
sealed class DuesEvent {}

class GetDuesListEvent extends DuesEvent {}
