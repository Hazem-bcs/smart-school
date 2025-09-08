import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:teacher_feat/domain/teacher_entity.dart';
import 'package:teacher_feat/domain/use_cases/get_teacher_by_id_use_case.dart';

part 'teacher_details_event.dart';
part 'teacher_details_state.dart';

class TeacherDetailsBloc extends Bloc<TeacherDetailsEvent, TeacherDetailsState> {
  final GetTeacherByIdUseCase teacherByIdUseCase;

  TeacherDetailsBloc({required this.teacherByIdUseCase}) : super(TeacherDetailsInitial()) {
    on<GetTeacherById>(_onGetTeacherById);
  }

  Future<void> _onGetTeacherById(GetTeacherById event, Emitter<TeacherDetailsState> emit) async {
    debugPrint('TeacherDetailsBloc: start GetTeacherById id=${event.teacherId}');
    emit(TeacherDetailsLoading());
    final result = await teacherByIdUseCase(event.teacherId);
    result.fold(
      (failure) {
        debugPrint('TeacherDetailsBloc: failure -> ${failure.message} (${failure.statusCode})');
        emit(TeacherDetailsError(message: failure.message));
      },
      (teacher) {
        debugPrint('TeacherDetailsBloc: success -> id=${teacher.id}, name=${teacher.name}');
        emit(TeacherDetailsLoaded(teacher: teacher));
      },
    );
  }
} 