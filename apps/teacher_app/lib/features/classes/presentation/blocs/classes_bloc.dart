import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'classes_event.dart';
part 'classes_state.dart';

class ClassesBloc extends Bloc<ClassesEvent, ClassesState> {
  ClassesBloc() : super(ClassesInitial()) {
    on<LoadClasses>(_onLoadClasses);
    on<SelectClass>(_onSelectClass);
  }

  void _onLoadClasses(
    LoadClasses event,
    Emitter<ClassesState> emit,
  ) async {
    emit(ClassesLoading());
    
    try {
      // TODO: Implement load classes logic
      // final classes = await classesRepository.getTeacherClasses();
      
      // Mock data for now
      await Future.delayed(const Duration(seconds: 1));
      final mockClasses = [
        ClassModel(id: '1', name: 'الصف الأول أ', subject: 'الرياضيات', studentsCount: 25),
        ClassModel(id: '2', name: 'الصف الثاني ب', subject: 'العلوم', studentsCount: 30),
        ClassModel(id: '3', name: 'الصف الثالث ج', subject: 'اللغة العربية', studentsCount: 28),
      ];
      
      emit(ClassesLoaded(classes: mockClasses));
    } catch (e) {
      emit(ClassesError(e.toString()));
    }
  }

  void _onSelectClass(
    SelectClass event,
    Emitter<ClassesState> emit,
  ) {
    // TODO: Navigate to home page with selected class
    emit(ClassSelected(selectedClass: event.classModel));
  }
}

// Model class for Class
class ClassModel {
  final String id;
  final String name;
  final String subject;
  final int studentsCount;

  ClassModel({
    required this.id,
    required this.name,
    required this.subject,
    required this.studentsCount,
  });
} 