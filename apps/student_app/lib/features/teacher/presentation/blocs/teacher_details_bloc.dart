import 'package:flutter_bloc/flutter_bloc.dart';
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
    emit(TeacherDetailsLoading());
    final result = await teacherByIdUseCase(event.teacherId);
    result.fold(
      (failure) => emit(TeacherDetailsError(message: failure.message)),
      (teacher) => emit(TeacherDetailsLoaded(teacher: teacher)),
    );
  }
} 