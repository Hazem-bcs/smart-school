import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:core/network/failures.dart';
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
    emit(NewAssignmentLoading());
    final Either<Failure, Unit> result = await addNewAssignmentUseCase(event.assignment);
    result.fold(
      (failure) => emit(NewAssignmentFailure(_mapFailureToArabic(failure))),
      (_) => emit(NewAssignmentSent()),
    );
  }

  Future<void> _onGetClasses(GetClassesEvent event, Emitter<NewAssignmentState> emit) async {
    emit(NewAssignmentLoading());
    final Either<Failure, List<String>> result = await getClassesUseCase();
    result.fold(
      (failure) => emit(NewAssignmentFailure(_mapFailureToArabic(failure))),
      (classes) => emit(NewAssignmentClassesLoaded(classes)),
    );
  }

  String _mapFailureToArabic(Failure failure) {
    final String msg = failure.message;
    if (failure is ConnectionFailure) return 'انقطاع الاتصال. حاول مرة أخرى';
    if (failure is ValidationFailure) return msg.isNotEmpty ? msg : 'بيانات غير صحيحة';
    if (failure is UnAuthenticated) return 'انتهت صلاحية الجلسة. يرجى تسجيل الدخول';
    if (failure is ServerFailure) return msg.isNotEmpty ? msg : 'خطأ من الخادم';
    return msg.isNotEmpty ? msg : 'حدث خطأ غير متوقع';
  }
} 