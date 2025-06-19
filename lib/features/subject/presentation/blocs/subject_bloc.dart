import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:smart_school/features/subject/domain/get_subject_use_case.dart';

import '../../domain/subject_entity.dart';

part 'subject_event.dart';
part 'subject_state.dart';

class SubjectBloc extends Bloc<SubjectEvent, SubjectState> {
  final GetSubjectUseCase getSubjectUseCase;
  SubjectBloc({required this.getSubjectUseCase}) : super(SubjectInitial()) {
    on<GetSubjectEvent>(_onGetSubject);
  }

  Future<void> _onGetSubject(GetSubjectEvent event, Emitter<SubjectState> emit) async {
    emit(SubjectLoading());
    final result = await getSubjectUseCase(event.id);
    result.fold(
      (fail) => emit(SubjectFailure(message: fail.message)),
      (subject) => emit(SubjectLoaded(subjectEntity: subject)),
    );
  }
}
