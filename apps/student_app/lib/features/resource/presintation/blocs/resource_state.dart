part of 'resource_bloc.dart';

@immutable
sealed class ResourceState {}

final class ResourceInitial extends ResourceState {}

final class GetResourceDataLoadingState extends ResourceState {}

final class ResourceDataListLoadedState extends ResourceState {
  final List<ResourceEntity> resourceList;

  ResourceDataListLoadedState({required this.resourceList});
}

final class ResourceErrorState extends ResourceState {
  final String message;

  ResourceErrorState({required this.message});
}