import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entites/homework_entity.dart';
import '../../domain/usecases/get_homework_use_case.dart';
part 'homework_event.dart';
part 'homework_state.dart';

class HomeworkBloc extends Bloc<HomeworkEvent, HomeworkState> {
  final GetHomeworkUseCase getHomework;
  // final UpdateHomeworkStatus updateHomeworkStatus; // You would inject this too

  HomeworkBloc({required this.getHomework}) : super(HomeworkInitial()) {
    on<GetHomeworksEvent>(_onGetHomeworks);
    // on<UpdateHomeworkStatusEvent>(_onUpdateStatus);
  }

  Future<void> _onGetHomeworks(GetHomeworksEvent event, Emitter<HomeworkState> emit) async {
    emit(HomeworkLoading());
    final result = await getHomework();
    result.fold(
          (failure) {
        emit(HomeworkFailure(message: 'Failed to load homework.'));
      },
          (homeworkList) {
        emit(HomeworkLoaded(homeworkList: homeworkList));
      },
    );
  }

// Handler for the new update event
// Future<void> _onUpdateStatus(UpdateHomeworkStatusEvent event, Emitter<HomeworkState> emit) async {
//   emit(HomeworkUpdateLoading());
//   final result = await updateHomeworkStatus(
//     homeworkId: event.homeworkId,
//     newStatus: event.newStatus,
//   );
//   result.fold(
//     (failure) => emit(HomeworkFailure(message: 'Failed to update status.')),
//     (_) {
//       emit(HomeworkUpdateSuccess());
//       // After updating, refresh the list
//       add(GetHomeworksEvent());
//     },
//   );
// }
}