part of 'classes_bloc.dart';

abstract class ClassesState extends Equatable {
  const ClassesState();

  @override
  List<Object> get props => [];
}

class ClassesInitial extends ClassesState {}

class ClassesLoading extends ClassesState {}

class ClassesLoaded extends ClassesState {
  final List<ClassModel> classes;

  const ClassesLoaded({required this.classes});

  @override
  List<Object> get props => [classes];
}

class ClassSelected extends ClassesState {
  final ClassModel selectedClass;

  const ClassSelected({required this.selectedClass});

  @override
  List<Object> get props => [selectedClass];
}

class ClassesError extends ClassesState {
  final String message;

  const ClassesError(this.message);

  @override
  List<Object> get props => [message];
} 