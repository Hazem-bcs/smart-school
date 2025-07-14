import 'package:equatable/equatable.dart';
import '../../domain/entities/class_entity.dart';
import '../../../assignment/domain/entities/assignment.dart';
import '../../domain/entities/notification_entity.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<ClassEntity> classes;
  final List<Assignment> assignments;
  final List<NotificationEntity> notifications;

  const HomeLoaded({
    required this.classes,
    required this.assignments,
    required this.notifications,
  });

  @override
  List<Object> get props => [classes, assignments, notifications];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object> get props => [message];
} 