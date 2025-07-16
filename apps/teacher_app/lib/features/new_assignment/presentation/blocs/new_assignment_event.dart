import '../../domain/entities/new_assignment_entity.dart';

abstract class NewAssignmentEvent {}

class OnPublish extends NewAssignmentEvent {
  final NewAssignmentEntity assignment;
  OnPublish(this.assignment);
}

class GetClassesEvent extends NewAssignmentEvent {} 