import 'package:core/domain/entities/subject_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:subject/domain/use_cases/get_subject_list_use_case.dart';
part 'subject_list_event.dart';
part 'subject_list_state.dart';

class SubjectListBloc extends Bloc<SubjectListEvent, SubjectListState> {
  final GetSubjectLListUseCase getSubjectLListUseCase;
  SubjectListBloc({required this.getSubjectLListUseCase}) : super(SubjectListInitial()) {
    on<GetSubjectListEvent>(_onGetSubjectListEvent);
  }

  Future<void> _onGetSubjectListEvent(GetSubjectListEvent event , Emitter<SubjectListState> emit) async {
    emit(SubjectListLoading());
    final result = await getSubjectLListUseCase();
    result.fold(
          (fail) => emit(SubjectListFailure(message: fail.message)),
          (subjectList) => emit(SubjectListLoaded(subjectEntityList: subjectList)),
    );
  }
}
