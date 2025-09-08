import 'package:core/domain/entities/subject_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subject/domain/use_cases/get_subject_use_case.dart';

part 'subject_event.dart';
part 'subject_state.dart';

class SubjectBloc extends Bloc<SubjectEvent, SubjectState> {
  final GetSubjectUseCase getSubjectUseCase;
  SubjectBloc({required this.getSubjectUseCase}) : super(SubjectInitial()) {
    on<GetSubjectDetailsEvent>(_onGetSubject);
  }

  Future<void> _onGetSubject(GetSubjectDetailsEvent event, Emitter<SubjectState> emit) async {
    debugPrint('SubjectBloc: start GetSubjectDetailsEvent id=${event.id}');
    emit(SubjectLoading());
    final result = await getSubjectUseCase(event.id);
    result.fold(
      (fail) {
        debugPrint('SubjectBloc: failure -> ${fail.message} (${fail.statusCode})');
        emit(SubjectFailure(message: fail.message));
      },
      (subject) {
        debugPrint('SubjectBloc: success -> id=${subject.id}, name=${subject.name}');
        emit(SubjectLoaded(subjectEntity: subject));
      },
    );
  }
}
