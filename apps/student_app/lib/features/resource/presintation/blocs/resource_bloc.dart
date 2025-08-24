import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:resource/domain/entities/resource_entity.dart';
import 'package:resource/domain/use_cases/get_resource_list_use_case.dart';

part 'resource_event.dart';
part 'resource_state.dart';

class ResourceBloc extends Bloc<ResourceEvent, ResourceState> {
  final GetResourceListUseCase getResourceListUseCase;

  ResourceBloc({required this.getResourceListUseCase}) : super(ResourceInitial()) {
    on<GetResourceDataListEvent>(_onGetResourceDataListEvent);
  }

  Future<void> _onGetResourceDataListEvent(GetResourceDataListEvent event , Emitter<ResourceState> emit) async {
    print('[ResourceBloc] GetResourceDataListEvent triggered');
    emit(GetResourceDataLoadingState());
    final result = await getResourceListUseCase();
    result.fold(
      (failure) {
        print('[ResourceBloc] Failed to load resources: ${failure.message}');
        emit(ResourceErrorState(message: failure.message));
      },
      (resourceList) {
        print('[ResourceBloc] Loaded resources: ${resourceList.length} items');
        emit(ResourceDataListLoadedState(resourceList: resourceList));
      },
    );
  }
}
