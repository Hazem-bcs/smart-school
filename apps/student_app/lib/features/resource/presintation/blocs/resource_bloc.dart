import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:resource/domain/entities/resource_entity.dart';
import 'package:resource/domain/use_cases/get_resource_list_use_case.dart';

part 'resource_event.dart';
part 'resource_state.dart';

/// Bloc لإدارة حالة صفحة الموارد
/// يتعامل مع جلب قائمة الموارد وإدارة حالات التحميل والأخطاء
class ResourceBloc extends Bloc<ResourceEvent, ResourceState> {
  final GetResourceListUseCase getResourceListUseCase;

  ResourceBloc({required this.getResourceListUseCase}) : super(ResourceInitial()) {
    on<GetResourceDataListEvent>(_onGetResourceDataListEvent);
  }

  /// معالج حدث جلب قائمة الموارد
  Future<void> _onGetResourceDataListEvent(
    GetResourceDataListEvent event, 
    Emitter<ResourceState> emit
  ) async {
    print('[ResourceBloc] تم تشغيل حدث جلب قائمة الموارد');
    emit(GetResourceDataLoadingState());
    
    final result = await getResourceListUseCase();
    result.fold(
      (failure) {
        print('[ResourceBloc] فشل في تحميل الموارد: ${failure.message}');
        emit(ResourceErrorState(message: failure.message));
      },
      (resourceList) {
        print('[ResourceBloc] تم تحميل الموارد: ${resourceList.length} عنصر');
        emit(ResourceDataListLoadedState(resourceList: resourceList));
      },
    );
  }
}
