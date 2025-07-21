abstract class NewAssignmentState {}

class NewAssignmentInitial extends NewAssignmentState {}
class NewAssignmentLoading extends NewAssignmentState {}
class NewAssignmentLoaded extends NewAssignmentState {}
class NewAssignmentSent extends NewAssignmentState {}
class NewAssignmentFailure extends NewAssignmentState {
  final String message;
  NewAssignmentFailure(this.message);
}
class NewAssignmentClassesLoaded extends NewAssignmentState {
  final List<String> classes;
  NewAssignmentClassesLoaded(this.classes);
} 