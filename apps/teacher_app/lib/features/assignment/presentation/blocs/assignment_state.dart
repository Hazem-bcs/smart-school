import 'package:equatable/equatable.dart';
import '../../domain/models/assignment.dart';

abstract class AssignmentState extends Equatable {
  const AssignmentState();
  @override
  List<Object?> get props => [];
}

class AssignmentInitial extends AssignmentState {}

class AssignmentLoading extends AssignmentState {}

class AssignmentLoaded extends AssignmentState {
  final List<Assignment> assignments;
  final String? searchQuery;
  final AssignmentStatus? filter;
  const AssignmentLoaded(this.assignments, {this.searchQuery, this.filter});

  @override
  List<Object?> get props => [assignments, searchQuery, filter];
}

class AssignmentError extends AssignmentState {
  final String message;
  const AssignmentError(this.message);

  @override
  List<Object?> get props => [message];
} 