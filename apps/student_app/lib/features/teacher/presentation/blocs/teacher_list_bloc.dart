import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:teacher_feat/domain/teacher_entity.dart';
import 'package:teacher_feat/domain/use_cases/get_teacher_list_use_case.dart';

part 'teacher_list_event.dart';
part 'teacher_list_state.dart';

class TeacherListBloc extends Bloc<TeacherListEvent, TeacherListState> {
  final GetTeacherListUseCase teacherListUseCase;

  TeacherListBloc({required this.teacherListUseCase}) : super(TeacherListInitial()) {
    on<GetTeacherList>(_onGetTeacherList);
  }

  Future<void> _onGetTeacherList(GetTeacherList event, Emitter<TeacherListState> emit) async {
    emit(TeacherListLoading());
    final result = await teacherListUseCase();
    result.fold(
      (failure) => emit(TeacherListError(message: failure.message)),
      (teacherList) => emit(TeacherListLoaded(teacherList: teacherList)),
    );
  }
} 