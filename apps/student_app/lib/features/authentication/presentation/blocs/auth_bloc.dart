import 'dart:async';

import 'package:auth/domain/usecases/cheakauthstatus_usecase.dart';
import 'package:auth/domain/usecases/login_usecase.dart';
import 'package:auth/domain/usecases/logout_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';



part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final CheckAuthStatusUseCase checkAuthStatusUseCase;
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;

  AuthBloc({
    required this.checkAuthStatusUseCase,
    required this.loginUseCase,
    required this.logoutUseCase,
  }) : super(AuthInitial()) {
    on<CheckAuthenticationStatusEvent>(_onCheckAuthenticationStatus);
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
  }

  // this for splash screen
  Future<void> _onCheckAuthenticationStatus(CheckAuthenticationStatusEvent event, Emitter<AuthState> emit) async {
    emit(AuthChecking());

    final result = await checkAuthStatusUseCase();

    result.fold(
          (failure) {
        emit(Unauthenticated());
      },
          (success) {
        emit(Authenticated());
      },
    );
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    // إصدار حالة التحميل أولاً
    emit(AuthChecking());

    // استدعاء الـ UseCase مع تمرير البيانات من الـ event
    final result = await loginUseCase(event.email, event.password);

    // التعامل مع النتيجة (نجاح أو فشل)
    result.fold(
          (failure) {
        // في حالة الفشل، نصدر حالة الفشل مع رسالة الخطأ
            print(failure);
        emit(LoginFailure(message: failure.message));
      },
          (success) {
        emit(Authenticated());
      },
    );
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthChecking());

    final result = await logoutUseCase();

    result.fold(
      (failure) {
        emit(LogoutFailure(message: failure.message));
      },
      (_) {
        emit(LogoutSuccess());
      },
    );
  }
}
