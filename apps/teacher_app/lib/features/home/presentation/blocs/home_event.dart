part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class LoadHomeData extends HomeEvent {
  final String className;

  const LoadHomeData(this.className);

  @override
  List<Object> get props => [className];
} 