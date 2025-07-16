import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/add_new_assignment_usecase.dart';
import '../../domain/usecases/get_classes_use_case.dart';
import 'new_assignment_event.dart';
import 'new_assignment_state.dart';

class NewAssignmentBloc extends Bloc<NewAssignmentEvent, NewAssignmentState> {
  final AddNewAssignmentUseCase addNewAssignmentUseCase;
  final GetClassesUseCase getClassesUseCase;
  NewAssignmentBloc({required this.addNewAssignmentUseCase, required this.getClassesUseCase}) : super(NewAssignmentInitial()) {
    on<OnPublish>(_onPublish);
    on<GetClassesEvent>(_onGetClasses);
  }

  Future<void> _onPublish(OnPublish event, Emitter<NewAssignmentState> emit) async {
    print('here1');
    emit(NewAssignmentLoading());
    
    print('here');
    try {
      await addNewAssignmentUseCase(event.assignment);
      emit(NewAssignmentSent());
    } catch (e) {
      emit(NewAssignmentFailure(e.toString()));
    }
  }

  Future<void> _onGetClasses(GetClassesEvent event, Emitter<NewAssignmentState> emit) async {
    emit(NewAssignmentLoading());
    try {
      final classes = await getClassesUseCase();
      emit(NewAssignmentClassesLoaded(classes));
    } catch (e) {
      emit(NewAssignmentFailure(e.toString()));
    }
  }
} 