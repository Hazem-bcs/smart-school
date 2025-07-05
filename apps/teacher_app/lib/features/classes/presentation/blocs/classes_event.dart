part of 'classes_bloc.dart';

abstract class ClassesEvent extends Equatable {
  const ClassesEvent();

  @override
  List<Object> get props => [];
}

class LoadClasses extends ClassesEvent {
  const LoadClasses();
}

class SelectClass extends ClassesEvent {
  final ClassModel classModel;

  const SelectClass(this.classModel);

  @override
  List<Object> get props => [classModel];
} 