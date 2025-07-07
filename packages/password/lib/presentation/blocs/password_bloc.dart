import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/change_password_usecase.dart';
import 'password_event.dart';
import 'password_state.dart';

class PasswordBloc extends Bloc<PasswordEvent, PasswordState> {
  final ChangePasswordUseCase changePasswordUseCase;

  PasswordBloc({required this.changePasswordUseCase}) : super(PasswordInitial()) {
    on<ChangePasswordRequested>(_onChangePasswordRequested);
    on<PasswordReset>(_onPasswordReset);
  }

  Future<void> _onChangePasswordRequested(
    ChangePasswordRequested event,
    Emitter<PasswordState> emit,
  ) async {
    emit(PasswordLoading());

    final result = await changePasswordUseCase(event.request);

    result.fold(
      (error) => emit(PasswordError(error)),
      (_) => emit(const PasswordSuccess('Password changed successfully')),
    );
  }

  void _onPasswordReset(
    PasswordReset event,
    Emitter<PasswordState> emit,
  ) {
    emit(PasswordInitial());
  }
} 