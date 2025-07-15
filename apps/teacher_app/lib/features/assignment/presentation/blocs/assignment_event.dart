import 'package:equatable/equatable.dart';
import '../../domain/entities/assignment.dart';

abstract class AssignmentEvent extends Equatable {
  const AssignmentEvent();
  @override
  List<Object?> get props => [];
}

class LoadAssignments extends AssignmentEvent {
  final String? searchQuery;
  final AssignmentStatus? filter;
  const LoadAssignments({this.searchQuery, this.filter});

  @override
  List<Object?> get props => [searchQuery, filter];
}

class AddAssignment extends AssignmentEvent {
  final Assignment assignment;
  const AddAssignment(this.assignment);

  @override
  List<Object?> get props => [assignment];
} 