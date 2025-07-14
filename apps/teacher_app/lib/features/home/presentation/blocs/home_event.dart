import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class LoadHomeData extends HomeEvent {
  const LoadHomeData();

  @override
  List<Object> get props => [];
}

class RefreshHomeData extends HomeEvent {
  const RefreshHomeData();

  @override
  List<Object> get props => [];
} 