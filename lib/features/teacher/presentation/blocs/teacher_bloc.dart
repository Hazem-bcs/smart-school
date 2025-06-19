import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:smart_school/core/network/failures.dart';
import 'package:smart_school/features/teacher/domain/teacher_entity.dart';
import 'package:smart_school/features/teacher/domain/use_cases/get_teacher_by_id_use_case.dart';
import 'package:smart_school/features/teacher/domain/use_cases/get_teacher_list_use_case.dart';

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
