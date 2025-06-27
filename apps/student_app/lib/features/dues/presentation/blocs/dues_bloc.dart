import 'package:bloc/bloc.dart';
import 'package:dues/domain/entities/due_entity.dart';
import 'package:dues/domain/usecases/get_my_dues.dart';
import 'package:meta/meta.dart';

part 'dues_event.dart';
part 'dues_state.dart';

class DuesBloc extends Bloc<DuesEvent, DuesState> {
  final GetMyDuesUseCase getMyDuesUseCase;

  DuesBloc({required this.getMyDuesUseCase}) : super(DuesInitial()) {
    on<GetDuesListEvent>(_getDuesList);
  }

  Future<void> _getDuesList(GetDuesListEvent event , Emitter<DuesState> emit) async {
    emit(DuesDataLoadingState());
    final result = await getMyDuesUseCase();
    result.fold(
      (failure) => emit(DuesErrorState(message: failure.message)),
      (duesList) => emit(DuesDataLoadedState(dueList: duesList)),
    );
}
}
