part of 'resource_bloc.dart';

@immutable
sealed class ResourceEvent {}

class GetResourceDataListEvent extends ResourceEvent {}