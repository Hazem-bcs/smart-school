import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
  }

  void _onLoadHomeData(
    LoadHomeData event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    
    try {
      // TODO: Implement load home data logic
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock data
      final mockData = HomeData(
        className: event.className,
        totalStudents: 25,
        presentToday: 23,
        assignments: 5,
        announcements: 3,
      );
      
      emit(HomeLoaded(data: mockData));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}

class HomeData {
  final String className;
  final int totalStudents;
  final int presentToday;
  final int assignments;
  final int announcements;

  HomeData({
    required this.className,
    required this.totalStudents,
    required this.presentToday,
    required this.assignments,
    required this.announcements,
  });
} 