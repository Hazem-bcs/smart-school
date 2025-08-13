import 'package:flutter_bloc/flutter_bloc.dart';
import 'settings_event.dart';
import 'settings_state.dart';
import '../../domain/usecases/logout_usecase.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final LogoutUseCase logoutUseCase;
  
  SettingsBloc({required this.logoutUseCase}) : super(SettingsInitial()) {
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<SettingsState> emit,
  ) async {
    emit(LogoutLoading());
    
    final result = await logoutUseCase();
    
    result.fold(
      (failure) => emit(LogoutFailure(message: failure.message)),
      (logoutResult) => emit(LogoutSuccess(logoutResult: logoutResult)),
    );
  }
}
