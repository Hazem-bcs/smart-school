import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_feat/domain/teacher_entity.dart';
import 'package:teacher_feat/domain/use_cases/get_teacher_by_id_use_case.dart';
import 'package:teacher_feat/domain/use_cases/get_teacher_list_use_case.dart';

part 'teacher_event.dart';
part 'teacher_state.dart';

class TeacherBloc extends Bloc<TeacherEvent, TeacherState> {

  final GetTeacherListUseCase teacherListUseCase;
  final GetTeacherByIdUseCase teacherByIdUseCase;

  TeacherBloc({required this.teacherByIdUseCase, required this.teacherListUseCase}) : super(TeacherInitial()) {
    on<GetTeacherList>(_getTeacherList);
    on<GetTeacherById>(_getTeacherById);
  }

  Future<void> _getTeacherList(GetTeacherList event, Emitter<TeacherState> emit) async {
    emit(GetDataLoadingState());
    final result = await teacherListUseCase(event.studentId);
    result.fold(
          (failure) {
        emit(ErrorState(message: failure.message));
      },
          (teacherList) {
        emit(TeacherListLoadedState(teacherList: teacherList));
      },
    );
  }

  Future<void> _getTeacherById(GetTeacherById event, Emitter<TeacherState> emit) async {
    emit(GetDataLoadingState());
    final result = await teacherByIdUseCase(event.teacherId);
    result.fold(
          (failure) {
        emit(ErrorState(message: failure.message));
      },
          (teacher) {
        emit(TeacherByIdLoadedState(teacher: teacher));
      },
    );
  }

}
